-- =============================================================================
-- 0011_arrivals.sql — "I'm at the gym."
--
-- Everything else in this product is RETROSPECTIVE: you log a session after it
-- happened, so the feed tells you what you already missed. An arrival is
-- PROSPECTIVE — it is announced at the one moment when somebody else can still
-- act on it, which is the only moment social proof actually moves anyone.
--
-- The mechanism is descriptive norms: "people like me are doing this right now"
-- changes behaviour far more reliably than "you should train more". A feed of
-- finished workouts is an injunctive norm and it is easy to ignore. Three
-- crewmates on the gym floor at 18:40 is a descriptive one, and it is not.
--
-- Design decisions worth defending:
--
--   * ARRIVALS EXPIRE. This is not a status you forget to switch off. A stale
--     "at the gym" flag is worse than none, because it teaches the crew that the
--     signal is noise. Each arrival carries its own expires_at.
--   * ONE ACTIVE PER MEMBER PER CREW, enforced by a partial unique index rather
--     than by whichever code path happens to call announce_arrival().
--   * SELF-DECLARED, not geolocated. Location permission is a real cost and a
--     false arrival fools your friends exactly once. The trust model is the
--     product's, not the database's.
-- =============================================================================

create type arrival_status as enum ('on_the_way', 'training');

create table public.arrivals (
  id            uuid           primary key default gen_random_uuid(),
  user_id       uuid           not null references public.profiles(id) on delete cascade,
  havura_id     uuid           not null references public.havuras(id) on delete cascade,
  status        arrival_status not null default 'training',
  note          text           check (char_length(note) <= 120),
  announced_at  timestamptz    not null default now(),
  expires_at    timestamptz    not null,
  closed_at     timestamptz,
  -- Set when the member logs the session this arrival led to. Closes the loop
  -- from "I'm going" to "here is what I did", which is the whole point.
  workout_id    uuid           references public.workouts(id) on delete set null,

  constraint arrivals_window_forward check (expires_at > announced_at)
);

-- At most one open arrival per member per crew. announce_arrival() closes the
-- previous one first, so this index is an assertion rather than an obstacle.
create unique index arrivals_one_open_per_crew
  on public.arrivals (user_id, havura_id)
  where closed_at is null;

-- The hot read: "who is at the gym right now", newest first.
create index arrivals_havura_open_idx
  on public.arrivals (havura_id, expires_at desc)
  where closed_at is null;

-- ---------------------------------------------------------------------------
-- active_arrivals — who is out right now, ready to render.
-- security_invoker, for the same reason as every other view here.
-- ---------------------------------------------------------------------------
create view public.active_arrivals
with (security_invoker = on) as
select
  a.id,
  a.user_id,
  a.havura_id,
  a.status,
  a.note,
  a.announced_at,
  a.expires_at,
  p.display_name
from public.arrivals a
join public.profiles p on p.id = a.user_id
where a.closed_at is null
  and a.expires_at > now();

grant select on public.arrivals        to authenticated;
grant select on public.active_arrivals to authenticated;

alter table public.arrivals enable row level security;

-- Crew-scoped, exactly like workouts. Your gym attendance is visible to the
-- people you train with and to nobody else.
create policy arrivals_select_crew on public.arrivals
  for select to authenticated
  using (public.is_havura_member(havura_id));

-- ---------------------------------------------------------------------------
-- announce_arrival — "on my way" or "I'm here".
--
-- The window is chosen by the SERVER from the status, never sent by the caller:
-- a client that could pick its own expiry could park itself at the top of the
-- crew's screen indefinitely.
-- ---------------------------------------------------------------------------
create or replace function public.announce_arrival(
  p_havura_id uuid,
  p_status    arrival_status default 'training',
  p_note      text default null
)
returns uuid
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_uid    uuid := auth.uid();
  v_window interval;
  v_id     uuid;
begin
  if v_uid is null then
    raise exception 'UNAUTHENTICATED' using errcode = 'insufficient_privilege';
  end if;

  if not public.is_havura_member(p_havura_id) then
    raise exception 'NOT_A_MEMBER' using errcode = 'insufficient_privilege';
  end if;

  -- "On my way" is a shorter promise than "I am here", and should go quiet
  -- sooner if it turns out not to be true.
  v_window := case p_status
                when 'on_the_way' then interval '45 minutes'
                else interval '150 minutes'
              end;

  -- Replace rather than reject: announcing again is how a member escalates from
  -- on_the_way to training, and it must not collide with the unique index.
  update public.arrivals
  set closed_at = least(now(), expires_at)
  where user_id = v_uid and havura_id = p_havura_id and closed_at is null;

  insert into public.arrivals (user_id, havura_id, status, note, expires_at)
  values (v_uid, p_havura_id, p_status, nullif(trim(p_note), ''), now() + v_window)
  returning id into v_id;

  return v_id;
end;
$$;

-- ---------------------------------------------------------------------------
-- close_arrival — "I'm done", or "actually, I'm not going".
-- ---------------------------------------------------------------------------
create or replace function public.close_arrival(p_havura_id uuid)
returns void
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_uid uuid := auth.uid();
begin
  if v_uid is null then
    raise exception 'UNAUTHENTICATED' using errcode = 'insufficient_privilege';
  end if;

  update public.arrivals
  set closed_at = now()
  where user_id = v_uid and havura_id = p_havura_id and closed_at is null;
end;
$$;

revoke all on function public.announce_arrival(uuid, arrival_status, text) from public, anon, authenticated;
revoke all on function public.close_arrival(uuid)                          from public, anon, authenticated;

grant execute on function public.announce_arrival(uuid, arrival_status, text) to authenticated;
grant execute on function public.close_arrival(uuid)                          to authenticated;

-- ---------------------------------------------------------------------------
-- Close the loop: logging a session ends the arrival it came from, and records
-- which workout it produced. Without this the member has to remember to switch
-- themselves off, and nobody ever does.
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

  -- The arrival becomes the session it turned into.
  update public.arrivals
  set closed_at = now(), workout_id = v_id
  where user_id = v_uid and havura_id = p_havura_id and closed_at is null;

  return v_id;
end;
$$;
