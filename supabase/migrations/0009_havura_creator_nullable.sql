-- =============================================================================
-- 0009_havura_creator_nullable.sql — deleting an account was impossible for
-- anyone who had ever created a crew.
--
-- Every foreign key pointing at profiles cascades on delete, except one:
--
--     havuras.created_by references profiles(id)      -- no action = RESTRICT
--
-- profiles.id cascades from auth.users, so deleting an auth user tries to delete
-- the profile, which the restricting reference then blocks. The result is
-- `Database error deleting user` with a 500, and an account that can never be
-- removed. Found by running the demo seed, which deletes and recreates its
-- accounts — the founder was the one it could not delete.
--
-- CASCADE would be the wrong repair and a far worse bug: deleting the founder
-- would delete the crew, and the crew's cascade would take every member's
-- workouts with it. One person closing their account would erase nine other
-- people's training history.
--
-- SET NULL is the honest model. A crew is a shared object that outlives the
-- account that happened to open it. The record of who created it is a nice
-- attribution, not a structural dependency — havura_members already holds the
-- ownership that actually matters, and it cascades correctly.
-- =============================================================================

alter table public.havuras
  alter column created_by drop not null;

alter table public.havuras
  drop constraint havuras_created_by_fkey;

alter table public.havuras
  add constraint havuras_created_by_fkey
  foreign key (created_by) references public.profiles(id) on delete set null;
