-- =============================================================================
-- 0010_feed_cursor_index.sql — make the compound feed cursor a range scan.
--
-- The crew feed pages on (performed_at, id) rather than performed_at alone, so
-- that two sessions logged in the same minute cannot make the second page skip
-- rows sharing that instant. For the seek to stay a range scan rather than a
-- filter, the index has to carry the tie-breaker column in the same order the
-- query asks for it.
-- =============================================================================

drop index if exists workouts_havura_performed_idx;

create index workouts_havura_feed_idx
  on public.workouts (havura_id, performed_at desc, id desc);
