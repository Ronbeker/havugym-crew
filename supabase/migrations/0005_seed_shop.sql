-- =============================================================================
-- 0005_seed_shop.sql — the cosmetic shop catalogue.
--
-- Everything purchasable is cosmetic on purpose. Creatine buys a title next to
-- your name, a badge on your feed card, or a colour theme — never a scoring
-- advantage, never a shortcut in a competition. That keeps the paid currency
-- out of the fairness argument: a member who spends money cannot out-rank a
-- member who trains harder, which is the only version of this economy that
-- survives contact with a real friend group.
-- =============================================================================

insert into public.shop_items (slug, name, kind, price_creatine) values
  -- Titles — shown beside the display name on every feed card and leaderboard row.
  ('title_rookie',        'Rookie',          'title',  150),
  ('title_regular',       'Regular',         'title',  400),
  ('title_the_grinder',   'The Grinder',     'title',  900),
  ('title_iron_disciple', 'Iron Disciple',   'title', 1600),
  ('title_volume_king',   'Volume King',     'title', 2400),
  ('title_the_metronome', 'The Metronome',   'title', 3200),
  ('title_unbreakable',   'Unbreakable',     'title', 5000),

  -- Badges — a small mark on the profile.
  ('badge_first_light',   'First Light',     'badge',  200),
  ('badge_century',       'Century Club',    'badge',  750),
  ('badge_pr_hunter',     'PR Hunter',       'badge', 1200),
  ('badge_night_shift',   'Night Shift',     'badge', 1200),
  ('badge_full_house',    'Full House',      'badge', 2000),

  -- Themes — app colour schemes.
  ('theme_chalk',         'Chalk',           'theme',  600),
  ('theme_midnight',      'Midnight',        'theme', 1400),
  ('theme_forge',         'Forge',           'theme', 2200),
  ('theme_sunrise',       'Sunrise',         'theme', 3000);
