-- =============================================================================
-- 0008_revoke_view_grants.sql — the views were readable by `anon`.
--
-- 0002 ran `revoke all on all tables in schema public from anon, authenticated`
-- and then granted back deliberately. But ALL TABLES only affects objects that
-- exist AT THAT MOMENT, and the two views were created four migrations later in
-- 0006. Supabase's DEFAULT PRIVILEGES then granted the new views to anon and
-- authenticated automatically, silently undoing the posture 0002 established.
--
-- The exposure did not become a leak, because the views carry
-- security_invoker = on: the caller's own privileges on the base tables are
-- still checked, and anon has none, so an anonymous request got
-- `42501 permission denied for table workouts` rather than data. Two independent
-- controls, one of them wrong, and the other one held. That is the entire
-- argument for defence in depth, and it is worth stating plainly rather than
-- quietly patching.
--
-- Fixed twice over: revoke what was granted, and change the default so the next
-- object created in this schema does not repeat it.
-- =============================================================================

revoke all on public.workout_feed      from anon;
revoke all on public.weekly_user_stats from anon;

-- Stops the same thing happening to the next view or table anyone adds.
alter default privileges in schema public revoke all on tables    from anon;
alter default privileges in schema public revoke all on sequences from anon;
