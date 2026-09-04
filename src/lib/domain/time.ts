/**
 * Week boundaries, computed in the gym's local timezone.
 *
 * This looks like over-engineering and is not. Every weekly challenge and every
 * competition is bucketed by week, and timestamps are stored as UTC. A session
 * logged at 01:00 on Sunday in Israel is 22:00 on Saturday in UTC — bucket it by
 * the UTC date and it lands in the previous week, so the athlete's Sunday
 * session pays into a competition that already settled.
 *
 * This is not hypothetical: the production HavuGym had exactly this bug, where a
 * UTC-stored started_at was read with a local hour-of-day and came out three
 * hours wrong.
 */
export const GYM_TIMEZONE = 'Asia/Jerusalem';

/** Weeks run Sunday → Saturday, which is the Israeli working week. */
const WEEK_STARTS_ON = 0;

interface LocalParts {
  year: number;
  month: number;
  day: number;
  weekday: number;
}

function localParts(date: Date, timeZone: string): LocalParts {
  const parts = new Intl.DateTimeFormat('en-US', {
    timeZone,
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    weekday: 'short',
  }).formatToParts(date);

  const lookup = (type: string) => parts.find((p) => p.type === type)?.value ?? '';
  const weekdayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  return {
    year: Number(lookup('year')),
    month: Number(lookup('month')),
    day: Number(lookup('day')),
    weekday: weekdayNames.indexOf(lookup('weekday')),
  };
}

const iso = (y: number, m: number, d: number) =>
  `${y}-${String(m).padStart(2, '0')}-${String(d).padStart(2, '0')}`;

/** The calendar date, in the gym's timezone, of the Sunday starting this week. */
export function weekStartOf(date: Date, timeZone: string = GYM_TIMEZONE): string {
  const { year, month, day, weekday } = localParts(date, timeZone);
  const daysSinceStart = (weekday - WEEK_STARTS_ON + 7) % 7;

  // Step back in whole days using a UTC anchor at midday, which keeps the
  // arithmetic clear of daylight-saving transitions.
  const anchor = Date.UTC(year, month - 1, day, 12);
  const start = new Date(anchor - daysSinceStart * 86_400_000);

  return iso(start.getUTCFullYear(), start.getUTCMonth() + 1, start.getUTCDate());
}

/** The Saturday that ends the week beginning on `weekStart` (YYYY-MM-DD). */
export function weekEndOf(weekStart: string): string {
  const [y, m, d] = weekStart.split('-').map(Number);
  const end = new Date(Date.UTC(y, m - 1, d, 12) + 6 * 86_400_000);
  return iso(end.getUTCFullYear(), end.getUTCMonth() + 1, end.getUTCDate());
}

/** Inclusive UTC instant range covering a local week — for querying timestamptz. */
export function weekRangeUtc(weekStart: string, timeZone: string = GYM_TIMEZONE) {
  const [y, m, d] = weekStart.split('-').map(Number);

  // Find the UTC instant of local midnight by probing the offset on that date.
  const probe = new Date(Date.UTC(y, m - 1, d, 12));
  const localMidday = localParts(probe, timeZone);
  const offsetMs =
    Date.UTC(localMidday.year, localMidday.month - 1, localMidday.day, 12) - probe.getTime();

  const startUtc = new Date(Date.UTC(y, m - 1, d) - offsetMs);
  const endUtc = new Date(startUtc.getTime() + 7 * 86_400_000);
  return { startUtc, endUtc };
}
