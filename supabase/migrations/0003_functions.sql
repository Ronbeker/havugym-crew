-- =============================================================================
-- 0003_functions.sql — the write path.
--
-- The client never INSERTs into workouts, havura_members, creatine_ledger,
-- inventory or orders. Every one of those writes happens inside a function
-- here, for three reasons:
--
--   * ATOMICITY. "Create a crew" is two inserts; "log a workout" is a parent
--     plus N children plus a score; "buy an item" is a debit plus a grant.
--     Each has to be all-or-nothing, and PostgREST gives us no transaction
--     across separate calls.
--   * TRUST. user_id always comes from auth.uid(), never from a parameter, so
--     no caller can act as somebody else even by calling the RPC directly.
--   * INVARIANTS. The creatine balance cache can only be written by
--     apply_creatine(), so it cannot drift from the ledger.
--
-- Every function is SECURITY DEFINER with a pinned search_path, and EXECUTE is
-- revoked from PUBLIC then granted deliberately at the bottom of the file.
-- =============================================================================

-- ---------------------------------------------------------------------------
-- generate_invite_code — 6 chars from an unambiguous alphabet (no O/0/I/1),
-- retried on collision. 32^6 ≈ 1.07e9 codes; collisions are handled rather
-- than assumed away.
-- ---------------------------------------------------------------------------
create or replace function public.generate_invite_code()
returns text
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  alphabet constant text := 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  candidate text;
  attempt   integer := 0;
begin
  loop
    candidate := '';
    for i in 1..6 loop
      candidate := candidate || substr(alphabet, floor(random() * length(alphabet))::int + 1, 1);
    end loop;

    exit when not exists (select 1 from public.havuras where invite_code = candidate);

    attempt := attempt + 1;
    if attempt > 20 then
      raise exception 'could not allocate a unique invite code after 20 attempts';
    end if;
  end loop;

  return candidate;
end;
$$;

-- ---------------------------------------------------------------------------
-- apply_creatine — THE single mutation point for the currency.
--
-- Takes a row lock on the profile so two concurrent spends cannot both read the
-- same balance and both succeed. Writes the ledger row and the cache together,
-- so they are updated in one transaction or not at all.
--
-- Idempotent when given a ref_id: the partial unique index on creatine_ledger
-- raises unique_violation on a replay, which we swallow and answer with the
-- balance as it already stands. That is what makes a re-delivered Stripe
-- webhook or a double-clicked Buy button harmless.
-- ---------------------------------------------------------------------------
create or replace function public.apply_creatine(
  p_user_id  uuid,
  p_delta    integer,
  p_reason   ledger_reason,
  p_ref_type text default null,
  p_ref_id   text default null
)
returns integer
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_balance integer;
begin
  if p_delta = 0 then
    raise exception 'apply_creatine: delta must be non-zero';
  end if;

  -- Serialises concurrent currency changes for this user.
  select creatine_balance into v_balance
  from public.profiles
  where id = p_user_id
  for update;

  if not found then
    raise exception 'apply_creatine: no such profile %', p_user_id;
  end if;

  if v_balance + p_delta < 0 then
    raise exception 'INSUFFICIENT_CREATINE: balance % cannot absorb %', v_balance, p_delta
      using errcode = 'check_violation';
  end if;

  v_balance := v_balance + p_delta;

  begin
    insert into public.creatine_ledger (user_id, delta, reason, ref_type, ref_id, balance_after)
    values (p_user_id, p_delta, p_reason, p_ref_type, p_ref_id, v_balance);
  exception when unique_violation then
    -- Already applied. Report the balance we actually have, not the one we
    -- would have had, and leave the cache untouched.
    select creatine_balance into v_balance from public.profiles where id = p_user_id;
    return v_balance;
  end;

  update public.profiles set creatine_balance = v_balance where id = p_user_id;

  return v_balance;
end;
$$;

-- ---------------------------------------------------------------------------
-- handle_new_user — every auth.users row gets a profile and a signup bonus.
-- Runs inside the signup transaction, so a user can never exist without one.
-- ---------------------------------------------------------------------------
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_name text;
begin
  v_name := coalesce(
    nullif(trim(new.raw_user_meta_data ->> 'display_name'), ''),
    split_part(new.email, '@', 1)
  );

  -- The column allows 2..32 chars; a one-character email local part would
  -- otherwise fail the check and take the whole signup down with it.
  v_name := rpad(left(v_name, 32), 2, '.');

  insert into public.profiles (id, display_name) values (new.id, v_name);

  perform public.apply_creatine(
    new.id, 100, 'signup_bonus', 'user', new.id::text
  );

  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ---------------------------------------------------------------------------
-- create_havura — crew plus the creator's owner membership, atomically.
-- ---------------------------------------------------------------------------
create or replace function public.create_havura(p_name text)
returns uuid
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_uid uuid := auth.uid();
  v_id  uuid;
begin
  if v_uid is null then
    raise exception 'UNAUTHENTICATED' using errcode = 'insufficient_privilege';
  end if;

  insert into public.havuras (name, invite_code, created_by)
  values (trim(p_name), public.generate_invite_code(), v_uid)
  returning id into v_id;

  insert into public.havura_members (havura_id, user_id, role)
  values (v_id, v_uid, 'owner');

  return v_id;
end;
$$;

-- ---------------------------------------------------------------------------
-- join_havura — the ONLY way to reach a crew you are not yet in.
--
-- Deliberately a function rather than a SELECT policy on invite_code: a policy
-- would let anyone probe for valid codes and learn which crews exist. Here the
-- code is a capability, and a wrong one is indistinguishable from a missing one.
-- ---------------------------------------------------------------------------
create or replace function public.join_havura(p_code text)
returns uuid
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_uid uuid := auth.uid();
  v_id  uuid;
begin
  if v_uid is null then
    raise exception 'UNAUTHENTICATED' using errcode = 'insufficient_privilege';
  end if;

  select id into v_id
  from public.havuras
  where invite_code = upper(trim(p_code));

  if v_id is null then
    raise exception 'INVALID_INVITE_CODE' using errcode = 'no_data_found';
  end if;

  insert into public.havura_members (havura_id, user_id, role)
  values (v_id, v_uid, 'member')
  on conflict (havura_id, user_id) do nothing;

  return v_id;
end;
$$;

-- ---------------------------------------------------------------------------
-- compute_workout_score — the intensity score, 0..100.
--
--   work per set = reps × (weight_kg + proxy), proxy = 30kg for bodyweight
--                  exercises (a pull-up is not zero work; we do not collect
--                  bodyweight, so we credit a flat nominal load and say so)
--   volume       = Σ work
--
--   Load     0..50 : 25 × min(volume  / median(volume),  2)
--   Density  0..30 : 15 × min(density / median(density), 2)   density = volume/min
--   Coverage 0..20 : 4 per distinct primary muscle, capped
--
-- Medians are over the user's PREVIOUS 8 workouts, so the score is relative to
-- the athlete's own baseline rather than to an absolute load. A beginner's hard
-- session and Ron's hard session both land near the same number, which is the
-- only way a shared crew leaderboard is fair.
--
-- With no history the ratios default to 1 (Load 25, Density 15) — a neutral
-- first score rather than a flattering or punishing one.
--
-- This is mirrored by scoreWorkout() in TypeScript; tests/score-parity asserts
-- the two agree on a fixed set of fixtures.
-- ---------------------------------------------------------------------------
create or replace function public.compute_workout_score(p_workout_id uuid)
returns numeric
language plpgsql
security definer
set search_path = public, pg_temp
stable
as $$
declare
  v_user_id  uuid;
  v_duration integer;
  v_volume   numeric;
  v_coverage integer;
  v_med_vol  numeric;
  v_med_den  numeric;
  v_load     numeric;
  v_density  numeric;
  v_cover    numeric;
begin
  select w.user_id, w.duration_min into v_user_id, v_duration
  from public.workouts w where w.id = p_workout_id;

  if v_user_id is null then
    raise exception 'compute_workout_score: no such workout %', p_workout_id;
  end if;

  select
    coalesce(sum(s.reps * (s.weight_kg + case when e.equipment = 'bodyweight' then 30 else 0 end)), 0),
    count(distinct e.muscle_primary)
  into v_volume, v_coverage
  from public.workout_sets s
  join public.exercises e on e.id = s.exercise_id
  where s.workout_id = p_workout_id;

  -- Baselines from the previous 8 workouts, this one excluded.
  with prev as (
    select w.id, w.duration_min
    from public.workouts w
    where w.user_id = v_user_id and w.id <> p_workout_id
    order by w.performed_at desc
    limit 8
  ), vols as (
    select p.duration_min,
           coalesce(sum(s.reps * (s.weight_kg + case when e.equipment = 'bodyweight' then 30 else 0 end)), 0) as vol
    from prev p
    left join public.workout_sets s on s.workout_id = p.id
    left join public.exercises e    on e.id = s.exercise_id
    group by p.id, p.duration_min
  )
  select percentile_cont(0.5) within group (order by vol),
         percentile_cont(0.5) within group (order by vol / nullif(duration_min, 0))
  into v_med_vol, v_med_den
  from vols;

  -- No usable history (first workout, or a degenerate all-zero baseline) means
  -- a ratio of exactly 1 rather than a division we cannot defend.
  if v_med_vol is null or v_med_vol <= 0 then
    v_load := 25;
  else
    v_load := 25 * least(v_volume / v_med_vol, 2);
  end if;

  if v_med_den is null or v_med_den <= 0 then
    v_density := 15;
  else
    v_density := 15 * least((v_volume / v_duration) / v_med_den, 2);
  end if;

  v_cover := least(v_coverage * 4, 20);

  return round(least(greatest(v_load + v_density + v_cover, 0), 100), 2);
end;
$$;

-- ---------------------------------------------------------------------------
-- log_workout — parent, children and score in one transaction.
--
-- p_sets is a flat JSON array:
--   [{"exercise_id":1,"set_index":1,"weight_kg":60,"reps":8,"rpe":8}, ...]
--
-- The score is computed here, from the rows as stored. It is never accepted
-- from the caller, so a client cannot award itself a 100.
-- ---------------------------------------------------------------------------
create or replace function public.log_workout(
  p_havura_id    uuid,
  p_performed_at timestamptz,
  p_title        text,
  p_notes        text,
  p_duration_min integer,
  p_sets         jsonb
)
returns uuid
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_uid uuid := auth.uid();
  v_id  uuid;
begin
  if v_uid is null then
    raise exception 'UNAUTHENTICATED' using errcode = 'insufficient_privilege';
  end if;

  if not public.is_havura_member(p_havura_id) then
    raise exception 'NOT_A_MEMBER' using errcode = 'insufficient_privilege';
  end if;

  if jsonb_typeof(p_sets) <> 'array' or jsonb_array_length(p_sets) = 0 then
    raise exception 'EMPTY_WORKOUT' using errcode = 'check_violation';
  end if;

  if jsonb_array_length(p_sets) > 200 then
    raise exception 'TOO_MANY_SETS' using errcode = 'check_violation';
  end if;

  insert into public.workouts (user_id, havura_id, performed_at, title, notes, duration_min, source)
  values (v_uid, p_havura_id, p_performed_at, trim(p_title), nullif(trim(p_notes), ''), p_duration_min, 'manual')
  returning id into v_id;

  insert into public.workout_sets (workout_id, exercise_id, set_index, weight_kg, reps, rpe)
  select v_id,
         (s ->> 'exercise_id')::integer,
         (s ->> 'set_index')::smallint,
         (s ->> 'weight_kg')::numeric,
         (s ->> 'reps')::smallint,
         nullif(s ->> 'rpe', '')::numeric
  from jsonb_array_elements(p_sets) as s;

  update public.workouts
  set score = public.compute_workout_score(v_id)
  where id = v_id;

  return v_id;
end;
$$;

-- ---------------------------------------------------------------------------
-- purchase_shop_item — debit then grant, atomically.
-- The ref_id is the item, so buying the same item twice is caught by the
-- ledger's unique index as well as by the inventory primary key.
-- ---------------------------------------------------------------------------
create or replace function public.purchase_shop_item(p_item_id integer)
returns void
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_uid   uuid := auth.uid();
  v_price integer;
  v_kind  shop_item_kind;
begin
  if v_uid is null then
    raise exception 'UNAUTHENTICATED' using errcode = 'insufficient_privilege';
  end if;

  select price_creatine, kind into v_price, v_kind
  from public.shop_items
  where id = p_item_id and active;

  if v_price is null then
    raise exception 'NO_SUCH_ITEM' using errcode = 'no_data_found';
  end if;

  if exists (select 1 from public.inventory where user_id = v_uid and item_id = p_item_id) then
    raise exception 'ALREADY_OWNED' using errcode = 'unique_violation';
  end if;

  -- Raises INSUFFICIENT_CREATINE and aborts the whole call if the wallet is
  -- short, so we can never hand over an item we were not paid for.
  perform public.apply_creatine(
    v_uid, -v_price, 'shop_purchase', 'shop_item', p_item_id::text
  );

  insert into public.inventory (user_id, item_id, item_kind)
  values (v_uid, p_item_id, v_kind);
end;
$$;

-- ---------------------------------------------------------------------------
-- equip_item — one equipped item per kind. The partial unique index enforces
-- this too; unequipping first is how we satisfy it without a constraint error.
-- ---------------------------------------------------------------------------
create or replace function public.equip_item(p_item_id integer)
returns void
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_uid  uuid := auth.uid();
  v_kind shop_item_kind;
begin
  if v_uid is null then
    raise exception 'UNAUTHENTICATED' using errcode = 'insufficient_privilege';
  end if;

  select item_kind into v_kind
  from public.inventory
  where user_id = v_uid and item_id = p_item_id;

  if v_kind is null then
    raise exception 'NOT_OWNED' using errcode = 'no_data_found';
  end if;

  update public.inventory set equipped = false
  where user_id = v_uid and item_kind = v_kind and equipped;

  update public.inventory set equipped = true
  where user_id = v_uid and item_id = p_item_id;
end;
$$;

-- ---------------------------------------------------------------------------
-- EXECUTE grants. Same default-deny posture as the table policies: strip
-- everything, then hand back exactly what the browser session needs.
--
-- apply_creatine and compute_workout_score are NOT granted to authenticated.
-- They are internal, called only from the functions above (which run as their
-- definer), and from the server using the service role.
-- ---------------------------------------------------------------------------
revoke all on function public.generate_invite_code()                                            from public, anon, authenticated;
revoke all on function public.apply_creatine(uuid, integer, ledger_reason, text, text)          from public, anon, authenticated;
revoke all on function public.compute_workout_score(uuid)                                        from public, anon, authenticated;
revoke all on function public.create_havura(text)                                                from public, anon, authenticated;
revoke all on function public.join_havura(text)                                                  from public, anon, authenticated;
revoke all on function public.log_workout(uuid, timestamptz, text, text, integer, jsonb)         from public, anon, authenticated;
revoke all on function public.purchase_shop_item(integer)                                        from public, anon, authenticated;
revoke all on function public.equip_item(integer)                                                from public, anon, authenticated;

grant execute on function public.create_havura(text)                                        to authenticated;
grant execute on function public.join_havura(text)                                          to authenticated;
grant execute on function public.log_workout(uuid, timestamptz, text, text, integer, jsonb) to authenticated;
grant execute on function public.purchase_shop_item(integer)                                to authenticated;
grant execute on function public.equip_item(integer)                                        to authenticated;
