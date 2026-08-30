-- =============================================================================
-- 0002_rls.sql — Row Level Security.
--
-- Posture: DEFAULT DENY. RLS is enabled on every table in public, and a table
-- with no policy for an operation rejects that operation for every non-service
-- role. Nothing is readable or writable unless a policy below says so.
--
-- Two things in here are worth reading closely, because both are traps we hit:
--
--   1. RECURSION. The natural policy for havura_members is "you may read rows
--      of a crew you belong to" — which queries havura_members from inside a
--      policy ON havura_members. Postgres detects the cycle and fails the query
--      with 42P17 infinite recursion. The fix is is_havura_member(), a SECURITY
--      DEFINER function: it runs as its owner, so it is not itself subject to
--      RLS, and the cycle is broken.
--
--   2. auth.uid() IS A FUNCTION CALL. Written bare in a policy it is re-evaluated
--      once per candidate row. Wrapped as (select auth.uid()) the planner hoists
--      it into an InitPlan and evaluates it once per query. On the crew feed that
--      is the difference between one call and one call per workout.
-- =============================================================================

-- ---------------------------------------------------------------------------
-- Helper functions. SECURITY DEFINER + a pinned search_path (so a caller cannot
-- shadow `public` with their own schema and hijack what these resolve to).
-- ---------------------------------------------------------------------------
create or replace function public.is_havura_member(p_havura_id uuid)
returns boolean
language sql
security definer
set search_path = public, pg_temp
stable
as $$
  select exists (
    select 1 from public.havura_members
    where havura_id = p_havura_id
      and user_id = (select auth.uid())
  );
$$;

create or replace function public.is_havura_owner(p_havura_id uuid)
returns boolean
language sql
security definer
set search_path = public, pg_temp
stable
as $$
  select exists (
    select 1 from public.havura_members
    where havura_id = p_havura_id
      and user_id = (select auth.uid())
      and role = 'owner'
  );
$$;

-- "Do I share at least one crew with this person?" — gates profile visibility.
create or replace function public.shares_havura_with(p_user_id uuid)
returns boolean
language sql
security definer
set search_path = public, pg_temp
stable
as $$
  select exists (
    select 1
    from public.havura_members me
    join public.havura_members them on them.havura_id = me.havura_id
    where me.user_id = (select auth.uid())
      and them.user_id = p_user_id
  );
$$;

-- ---------------------------------------------------------------------------
-- Grants. Defence in depth: RLS decides WHICH ROWS, grants decide WHICH TABLES
-- AND COLUMNS. Supabase hands `authenticated` broad default privileges on
-- public, so we take them back and re-issue only what the client actually needs.
-- ---------------------------------------------------------------------------
revoke all on all tables in schema public from anon, authenticated;

-- Anonymous visitors get nothing. Every route that renders data requires a session.
-- (No grants to `anon` at all — the landing page is static.)

grant select                        on public.exercises           to authenticated;
grant select                        on public.shop_items          to authenticated;
grant select                        on public.havuras             to authenticated;
grant select                        on public.havura_members      to authenticated;
grant select                        on public.workouts            to authenticated;
grant select                        on public.workout_sets        to authenticated;
grant select                        on public.challenges          to authenticated;
grant select                        on public.challenge_progress  to authenticated;
grant select                        on public.competitions        to authenticated;
grant select                        on public.competition_results to authenticated;
grant select                        on public.creatine_ledger     to authenticated;
grant select                        on public.inventory           to authenticated;
grant select                        on public.orders              to authenticated;
grant select                        on public.profiles            to authenticated;

-- COLUMN-LEVEL grant. Even with a permissive UPDATE policy, `authenticated`
-- physically cannot write creatine_balance — the privilege does not exist. This
-- is what stops "UPDATE profiles SET creatine_balance = 999999" from ever being
-- an interesting attack, independent of any policy we might get wrong later.
grant update (display_name, avatar_url) on public.profiles to authenticated;

-- The only writes the client may make directly. Everything else — currency,
-- workout creation, memberships, settlements, orders — moves through a SECURITY
-- DEFINER function or the service role, never through a raw client INSERT.
--
-- Note there is no INSERT on havuras: a direct insert would create a crew with
-- no membership row and no owner. create_havura() writes both or neither.
grant update, delete on public.havuras to authenticated;

-- Leaving a crew, or an owner removing a member.
grant delete on public.havura_members to authenticated;

-- COLUMN-LEVEL again, and for the same reason as profiles.creatine_balance:
-- with a bare `grant update on workouts` the permissive "update your own"
-- policy would happily allow  UPDATE workouts SET score = 100  on your own row.
-- You may correct what you wrote down. You may not grade yourself.
grant update (title, notes, performed_at, duration_min) on public.workouts to authenticated;
grant delete                                            on public.workouts to authenticated;

-- ---------------------------------------------------------------------------
-- Enable RLS everywhere. From this point the default answer is "no".
-- ---------------------------------------------------------------------------
alter table public.profiles            enable row level security;
alter table public.havuras             enable row level security;
alter table public.havura_members      enable row level security;
alter table public.exercises           enable row level security;
alter table public.workouts            enable row level security;
alter table public.workout_sets        enable row level security;
alter table public.challenges          enable row level security;
alter table public.challenge_progress  enable row level security;
alter table public.competitions        enable row level security;
alter table public.competition_results enable row level security;
alter table public.creatine_ledger     enable row level security;
alter table public.shop_items          enable row level security;
alter table public.inventory           enable row level security;
alter table public.orders              enable row level security;

-- ---------------------------------------------------------------------------
-- profiles
-- ---------------------------------------------------------------------------
-- You can always see yourself; you can see other people only through a shared
-- crew. This is what stops the app becoming a directory of every user.
create policy profiles_select_self_or_crewmate on public.profiles
  for select to authenticated
  using (id = (select auth.uid()) or public.shares_havura_with(id));

create policy profiles_update_self on public.profiles
  for update to authenticated
  using (id = (select auth.uid()))
  with check (id = (select auth.uid()));

-- ---------------------------------------------------------------------------
-- havuras
-- ---------------------------------------------------------------------------
-- Members only, and no INSERT policy at all (see create_havura). Note there is
-- also deliberately no policy allowing lookup by
-- invite_code: joining goes through join_havura(), so an attacker cannot
-- enumerate crews or confirm that a guessed code exists by SELECTing for it.
create policy havuras_select_member on public.havuras
  for select to authenticated
  using (public.is_havura_member(id));

create policy havuras_update_owner on public.havuras
  for update to authenticated
  using (public.is_havura_owner(id))
  with check (public.is_havura_owner(id));

create policy havuras_delete_owner on public.havuras
  for delete to authenticated
  using (public.is_havura_owner(id));

-- ---------------------------------------------------------------------------
-- havura_members  (see the recursion note at the top of this file)
-- ---------------------------------------------------------------------------
create policy havura_members_select_crewmate on public.havura_members
  for select to authenticated
  using (public.is_havura_member(havura_id));

-- Leave a crew (your own row) or, as owner, remove someone else.
create policy havura_members_delete_self_or_owner on public.havura_members
  for delete to authenticated
  using (user_id = (select auth.uid()) or public.is_havura_owner(havura_id));

-- ---------------------------------------------------------------------------
-- exercises / shop_items — global catalogues, read-only to every signed-in user.
-- ---------------------------------------------------------------------------
create policy exercises_select_all on public.exercises
  for select to authenticated using (true);

create policy shop_items_select_active on public.shop_items
  for select to authenticated using (active);

-- ---------------------------------------------------------------------------
-- workouts / workout_sets — visible to the crew they were logged into.
-- ---------------------------------------------------------------------------
create policy workouts_select_crew on public.workouts
  for select to authenticated
  using (public.is_havura_member(havura_id));

-- No INSERT policy: workouts are created only by log_workout() (0003), which
-- writes the parent and its sets in one transaction and computes the score
-- server-side. A client cannot invent a score for itself.
create policy workouts_update_own on public.workouts
  for update to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));

create policy workouts_delete_own on public.workouts
  for delete to authenticated
  using (user_id = (select auth.uid()));

create policy workout_sets_select_crew on public.workout_sets
  for select to authenticated
  using (exists (
    select 1 from public.workouts w
    where w.id = workout_sets.workout_id
      and public.is_havura_member(w.havura_id)
  ));

-- ---------------------------------------------------------------------------
-- challenges / competitions — crew-scoped read. All writes are server-side.
-- ---------------------------------------------------------------------------
create policy challenges_select_crew on public.challenges
  for select to authenticated
  using (public.is_havura_member(havura_id));

create policy challenge_progress_select_crew on public.challenge_progress
  for select to authenticated
  using (exists (
    select 1 from public.challenges c
    where c.id = challenge_progress.challenge_id
      and public.is_havura_member(c.havura_id)
  ));

create policy competitions_select_crew on public.competitions
  for select to authenticated
  using (public.is_havura_member(havura_id));

create policy competition_results_select_crew on public.competition_results
  for select to authenticated
  using (exists (
    select 1 from public.competitions c
    where c.id = competition_results.competition_id
      and public.is_havura_member(c.havura_id)
  ));

-- ---------------------------------------------------------------------------
-- creatine_ledger / inventory / orders — strictly private to the owner.
-- Your crewmates can see your workouts and your rank. They cannot see your
-- wallet, your purchases, or what you paid us.
-- ---------------------------------------------------------------------------
create policy ledger_select_own on public.creatine_ledger
  for select to authenticated
  using (user_id = (select auth.uid()));

create policy inventory_select_own on public.inventory
  for select to authenticated
  using (user_id = (select auth.uid()));

create policy orders_select_own on public.orders
  for select to authenticated
  using (user_id = (select auth.uid()));
