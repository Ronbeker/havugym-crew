-- =============================================================================
-- 0006_views.sql — read models.
--
-- Both views carry `security_invoker = on`. This matters more than it looks:
-- by default a view executes as its OWNER, which is postgres, which BYPASSES
-- Row Level Security on every underlying table. A view defined the default way
-- over `workouts` would happily serve every crew's sessions to anyone allowed to
-- select from the view — a complete RLS bypass, introduced by adding a view.
--
-- With security_invoker the view runs as the CALLER, so the policies in 0002
-- apply exactly as they do to the base tables.
--
-- Why views at all: the crew feed needs each workout plus its author's name, its
-- set count, its total volume and the muscles it hit. Assembled in the
-- application that is one query for the workouts and then one per workout for
-- the sets — the N+1 that turns a 20-row feed into 21 round trips to Frankfurt.
-- Here it is a single aggregate, and the planner can use the existing indexes.
-- =============================================================================

-- ---------------------------------------------------------------------------
-- workout_feed — one row per workout, ready to render.
-- ---------------------------------------------------------------------------
create view public.workout_feed
with (security_invoker = on) as
select
  w.id,
  w.havura_id,
  w.user_id,
  w.performed_at,
  w.title,
  w.notes,
  w.duration_min,
  w.score,
  w.source,
  w.created_at,
  p.display_name,
  count(s.id)::integer as set_count,
  coalesce(
    sum(s.reps * (s.weight_kg + case when e.equipment = 'bodyweight' then 30 else 0 end)),
    0
  )::numeric as volume,
  coalesce(
    array_agg(distinct e.muscle_primary) filter (where e.muscle_primary is not null),
    '{}'
  ) as muscles
from public.workouts w
join public.profiles p       on p.id = w.user_id
left join public.workout_sets s on s.workout_id = w.id
left join public.exercises e    on e.id = s.exercise_id
group by w.id, p.display_name;

-- ---------------------------------------------------------------------------
-- weekly_user_stats — per member, per crew, per week.
--
-- Feeds challenge progress, competition standings and the weekly report, so all
-- three read from ONE definition of "this week" and cannot disagree about it.
--
-- The week starts on SUNDAY, in Asia/Jerusalem. date_trunc('week') is
-- Monday-based and operates on whatever timezone it is handed, so the shift and
-- the explicit `at time zone` are both load-bearing: without them a Saturday
-- 23:00 session in Israel is stored as Saturday 20:00Z, read as a different
-- local day, and bucketed into the wrong week.
-- ---------------------------------------------------------------------------
create view public.weekly_user_stats
with (security_invoker = on) as
select
  w.havura_id,
  w.user_id,
  (
    date_trunc('week', (w.performed_at at time zone 'Asia/Jerusalem') + interval '1 day')
    - interval '1 day'
  )::date as week_start,
  count(distinct w.id)::integer as workout_count,
  coalesce(sum(w.score), 0)::numeric as total_score,
  coalesce(
    sum(s.reps * (s.weight_kg + case when e.equipment = 'bodyweight' then 30 else 0 end)),
    0
  )::numeric as total_volume,
  count(distinct e.muscle_primary)::integer as muscles_hit
from public.workouts w
left join public.workout_sets s on s.workout_id = w.id
left join public.exercises e    on e.id = s.exercise_id
group by w.havura_id, w.user_id, 3;

grant select on public.workout_feed      to authenticated;
grant select on public.weekly_user_stats to authenticated;
