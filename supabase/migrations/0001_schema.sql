-- =============================================================================
-- 0001_schema.sql — HavuGym Crew: enums, tables, constraints, indexes.
--
-- Design notes that the technical-design document expands on:
--   * A "havura" (crew) is the tenant boundary. Almost every row is reachable
--     only through a membership in one, which is what makes the RLS policies in
--     0002 both simple and complete.
--   * Creatine (the in-app currency) is an APPEND-ONLY LEDGER. profiles.creatine
--     _balance is a cache; the ledger is the truth. Every mutation goes through
--     one SECURITY DEFINER function (0003) so the cache can never drift.
--   * Idempotency is enforced by the database, not by application code — see the
--     partial unique indexes on workouts(external_id) and creatine_ledger(ref_id).
-- =============================================================================

-- ---------------------------------------------------------------------------
-- Enums. Preferred over CHECK-on-text because they are self-documenting, cheap
-- to index, and a typo becomes a migration error instead of a silent bad row.
-- ---------------------------------------------------------------------------
create type muscle_group as enum (
  'chest','back','shoulders','legs','glutes','core','biceps','triceps','cardio'
);

create type equipment_type as enum (
  'barbell','dumbbell','machine','cable','bodyweight','kettlebell','resistance_band','none'
);

create type movement_pattern as enum (
  'push_horizontal','push_vertical','pull_horizontal','pull_vertical',
  'squat','hinge','lunge','carry','rotation','static'
);

create type havura_role         as enum ('owner','member');
create type workout_source      as enum ('manual','hevy');
create type challenge_kind      as enum ('workout_count','total_volume','muscle_coverage');
create type competition_metric  as enum ('total_score','workout_count','total_volume');
create type competition_status  as enum ('open','settled');
create type shop_item_kind      as enum ('title','badge','theme');
create type order_status        as enum ('pending','paid','failed','expired');

create type ledger_reason as enum (
  'signup_bonus','challenge_reward','competition_payout',
  'shop_purchase','pack_purchase','admin_adjust'
);

-- ---------------------------------------------------------------------------
-- 1. profiles — one row per auth.users row, created by a trigger (0003).
-- ---------------------------------------------------------------------------
create table public.profiles (
  id                uuid primary key references auth.users(id) on delete cascade,
  display_name      text        not null check (char_length(display_name) between 2 and 32),
  avatar_url        text,
  -- Cache of sum(creatine_ledger.delta). Never written directly by the app.
  creatine_balance  integer     not null default 0 check (creatine_balance >= 0),
  created_at        timestamptz not null default now()
);

-- ---------------------------------------------------------------------------
-- 2. havuras — the crew. The tenant.
-- ---------------------------------------------------------------------------
create table public.havuras (
  id           uuid        primary key default gen_random_uuid(),
  name         text        not null check (char_length(name) between 2 and 40),
  -- Short human-typeable join code. Unique index doubles as the lookup path.
  invite_code  text        not null unique check (invite_code ~ '^[A-Z0-9]{6}$'),
  created_by   uuid        not null references public.profiles(id),
  created_at   timestamptz not null default now()
);

-- ---------------------------------------------------------------------------
-- 3. havura_members — the join table that every RLS policy pivots on.
-- ---------------------------------------------------------------------------
create table public.havura_members (
  havura_id  uuid        not null references public.havuras(id) on delete cascade,
  user_id    uuid        not null references public.profiles(id) on delete cascade,
  role       havura_role not null default 'member',
  joined_at  timestamptz not null default now(),
  primary key (havura_id, user_id)
);

-- The PK covers (havura_id, user_id). This second index covers the reverse
-- lookup "which crews is this user in", which is the hot path for every single
-- RLS check in the system, so it is emphatically not optional.
create index havura_members_user_idx on public.havura_members (user_id);

-- ---------------------------------------------------------------------------
-- 4. exercises — global read-only catalogue (660 rows, seeded in 0004).
-- ---------------------------------------------------------------------------
create table public.exercises (
  id                   integer          primary key generated always as identity,
  slug                 text             not null unique,
  name                 text             not null,
  -- 'cardio' is a legal SECONDARY muscle but never a primary one.
  muscle_primary       muscle_group     not null check (muscle_primary <> 'cardio'),
  muscle_secondary     muscle_group[]   not null default '{}',
  equipment            equipment_type   not null,
  movement_pattern     movement_pattern,
  is_unilateral        boolean          not null default false,
  default_rest_seconds integer          not null check (default_rest_seconds > 0),
  instructions         text             not null
);

create index exercises_muscle_primary_idx on public.exercises (muscle_primary);

-- ---------------------------------------------------------------------------
-- 5. workouts — the logged session. Written only via log_workout() (0003).
-- ---------------------------------------------------------------------------
create table public.workouts (
  id           uuid           primary key default gen_random_uuid(),
  user_id      uuid           not null references public.profiles(id) on delete cascade,
  havura_id    uuid           not null references public.havuras(id) on delete cascade,
  performed_at timestamptz    not null,
  title        text           not null check (char_length(title) between 1 and 60),
  notes        text           check (char_length(notes) <= 500),
  duration_min integer        not null check (duration_min between 1 and 480),
  -- The ingestion boundary: 'manual' today, 'hevy' when the adapter lands.
  source       workout_source not null default 'manual',
  external_id  text,
  score        numeric(5,2)   not null default 0 check (score between 0 and 100),
  created_at   timestamptz    not null default now()
);

-- Crew feed, newest first — the single most-run query in the product. Ordered
-- to serve keyset pagination (where havura_id = $1 and performed_at < $cursor).
create index workouts_havura_performed_idx on public.workouts (havura_id, performed_at desc);

-- Personal history + all per-user weekly aggregates.
create index workouts_user_performed_idx on public.workouts (user_id, performed_at desc);

-- Imported workouts are idempotent BY CONSTRUCTION: a re-run of the Hevy
-- adapter cannot create a duplicate, no matter what the application code does.
create unique index workouts_external_uniq
  on public.workouts (user_id, source, external_id)
  where external_id is not null;

-- ---------------------------------------------------------------------------
-- 6. workout_sets — the children of a workout.
-- ---------------------------------------------------------------------------
create table public.workout_sets (
  id          uuid         primary key default gen_random_uuid(),
  workout_id  uuid         not null references public.workouts(id) on delete cascade,
  exercise_id integer      not null references public.exercises(id),
  set_index   smallint     not null check (set_index between 1 and 20),
  -- 0 is legal: bodyweight exercises carry no external load.
  weight_kg   numeric(6,2) not null check (weight_kg between 0 and 500),
  reps        smallint     not null check (reps between 1 and 100),
  rpe         numeric(3,1) check (rpe between 1 and 10),
  unique (workout_id, exercise_id, set_index)
);

create index workout_sets_workout_idx on public.workout_sets (workout_id);

-- ---------------------------------------------------------------------------
-- 7-8. challenges — one cooperative goal per crew per week.
-- ---------------------------------------------------------------------------
create table public.challenges (
  id              uuid           primary key default gen_random_uuid(),
  havura_id       uuid           not null references public.havuras(id) on delete cascade,
  week_start      date           not null,
  kind            challenge_kind not null,
  target          integer        not null check (target > 0),
  reward_creatine integer        not null check (reward_creatine > 0),
  created_at      timestamptz    not null default now(),
  unique (havura_id, week_start)
);

create table public.challenge_progress (
  challenge_id uuid          not null references public.challenges(id) on delete cascade,
  user_id      uuid          not null references public.profiles(id) on delete cascade,
  value        numeric(10,2) not null default 0 check (value >= 0),
  completed_at timestamptz,
  -- Separate from completed_at on purpose: "hit the target" and "was paid for
  -- hitting the target" are different facts, and paid_at is the idempotency
  -- guard that stops a re-run from paying the reward twice.
  paid_at      timestamptz,
  primary key (challenge_id, user_id)
);

-- ---------------------------------------------------------------------------
-- 9-10. competitions — one competitive ranking per crew per week.
-- ---------------------------------------------------------------------------
create table public.competitions (
  id           uuid               primary key default gen_random_uuid(),
  havura_id    uuid               not null references public.havuras(id) on delete cascade,
  week_start   date               not null,
  metric       competition_metric not null,
  pot_creatine integer            not null check (pot_creatine > 0),
  status       competition_status not null default 'open',
  settled_at   timestamptz,
  unique (havura_id, week_start),
  -- A settled competition must carry its settlement timestamp, and an open one
  -- must not. Makes "is this settled?" a single unambiguous question.
  constraint competitions_settled_consistency check (
    (status = 'settled' and settled_at is not null) or
    (status = 'open'    and settled_at is null)
  )
);

create table public.competition_results (
  competition_id uuid          not null references public.competitions(id) on delete cascade,
  user_id        uuid          not null references public.profiles(id) on delete cascade,
  rank           smallint      not null check (rank > 0),
  value          numeric(10,2) not null check (value >= 0),
  payout         integer       not null default 0 check (payout >= 0),
  primary key (competition_id, user_id)
);

-- ---------------------------------------------------------------------------
-- 11. creatine_ledger — append-only. The source of truth for all currency.
-- ---------------------------------------------------------------------------
create table public.creatine_ledger (
  id            uuid          primary key default gen_random_uuid(),
  user_id       uuid          not null references public.profiles(id) on delete cascade,
  delta         integer       not null check (delta <> 0),
  reason        ledger_reason not null,
  ref_type      text,
  ref_id        text,
  -- Running balance snapshotted on every row: makes the ledger auditable on its
  -- own, and turns the "cache matches truth" invariant into a one-line test.
  balance_after integer       not null check (balance_after >= 0),
  created_at    timestamptz   not null default now()
);

create index creatine_ledger_user_idx on public.creatine_ledger (user_id, created_at desc);

-- Double-credit protection at the storage layer. A replayed Stripe webhook, a
-- double-clicked Buy button and a re-run settlement all collide here and lose.
create unique index creatine_ledger_ref_uniq
  on public.creatine_ledger (user_id, reason, ref_type, ref_id)
  where ref_id is not null;

-- ---------------------------------------------------------------------------
-- 12-13. shop — cosmetic items bought with creatine.
-- ---------------------------------------------------------------------------
create table public.shop_items (
  id             integer        primary key generated always as identity,
  slug           text           not null unique,
  name           text           not null,
  kind           shop_item_kind not null,
  price_creatine integer        not null check (price_creatine > 0),
  active         boolean        not null default true,
  -- Required so inventory can reference (id, kind) as a composite FK below.
  unique (id, kind)
);

create table public.inventory (
  user_id     uuid           not null references public.profiles(id) on delete cascade,
  item_id     integer        not null references public.shop_items(id),
  -- Denormalised from shop_items purely to make the "one equipped item per
  -- kind" rule enforceable by an index. The composite FK below guarantees it
  -- can never disagree with shop_items.kind.
  item_kind   shop_item_kind not null,
  acquired_at timestamptz    not null default now(),
  equipped    boolean        not null default false,
  primary key (user_id, item_id),
  foreign key (item_id, item_kind) references public.shop_items(id, kind)
);

-- At most one equipped title, one badge, one theme per user — enforced by the
-- database rather than by whichever code path happens to call equip().
create unique index inventory_one_equipped_per_kind
  on public.inventory (user_id, item_kind)
  where equipped;

-- ---------------------------------------------------------------------------
-- 14. orders — real-money creatine pack purchases via Stripe (test mode).
-- ---------------------------------------------------------------------------
create table public.orders (
  id                uuid         primary key default gen_random_uuid(),
  user_id           uuid         not null references public.profiles(id) on delete cascade,
  pack_slug         text         not null,
  creatine_amount   integer      not null check (creatine_amount > 0),
  amount_cents      integer      not null check (amount_cents > 0),
  currency          text         not null default 'ils' check (currency ~ '^[a-z]{3}$'),
  stripe_session_id text         not null unique,
  status            order_status not null default 'pending',
  created_at        timestamptz  not null default now(),
  credited_at       timestamptz,
  constraint orders_paid_consistency check (
    (status = 'paid' and credited_at is not null) or
    (status <> 'paid' and credited_at is null)
  )
);

create index orders_user_idx on public.orders (user_id, created_at desc);
