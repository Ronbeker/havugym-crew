-- =============================================================================
-- 0007_fix_display_name.sql — every display name was being truncated to two
-- characters.
--
-- handle_new_user() contained:
--
--     v_name := rpad(left(v_name, 32), 2, '.');
--
-- The intent was "pad a too-short name up to the two characters the CHECK
-- constraint demands". But rpad() does not only pad — when the input is LONGER
-- than the target length it TRUNCATES to it. So 'Dana' became 'Da', 'Itay'
-- became 'It', and the bug was invisible in the database (both are valid names)
-- and only obvious once four accounts existed side by side in a feed.
--
-- The fix pads conditionally, and only in the case that actually needs it.
-- =============================================================================

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

  -- Clamp to the column's upper bound.
  v_name := left(v_name, 32);

  -- Only pad if we are under the lower bound, so a one-character email local
  -- part cannot fail the CHECK and take the whole signup down with it.
  if char_length(v_name) < 2 then
    v_name := rpad(v_name, 2, '.');
  end if;

  insert into public.profiles (id, display_name) values (new.id, v_name);

  perform public.apply_creatine(
    new.id, 100, 'signup_bonus', 'user', new.id::text
  );

  return new;
end;
$$;

-- Repair the accounts already created with a truncated name, by re-reading the
-- name they actually signed up with from auth.users.
update public.profiles p
set display_name = left(
  coalesce(
    nullif(trim(u.raw_user_meta_data ->> 'display_name'), ''),
    split_part(u.email, '@', 1)
  ),
  32
)
from auth.users u
where u.id = p.id
  and char_length(p.display_name) = 2
  and char_length(
    coalesce(
      nullif(trim(u.raw_user_meta_data ->> 'display_name'), ''),
      split_part(u.email, '@', 1)
    )
  ) > 2;
