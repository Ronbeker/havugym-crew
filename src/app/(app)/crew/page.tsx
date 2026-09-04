import { redirect } from 'next/navigation';
import { TargetIcon, TrophyIcon, CheckIcon } from '@/components/icons';
import { InviteCode } from '@/components/invite-code';
import {
  getActiveHavura, getCrewRoster, getWeeklyStats,
} from '@/lib/queries';
import { challengeForWeek } from '@/lib/domain/challenge';
import { settleCompetition, type CompetitionEntry } from '@/lib/domain/competition';
import { weekStartOf, weekEndOf } from '@/lib/domain/time';
import { ensureWeek, settleDueWeeks, metricForWeek, COMPETITION_POT } from '@/lib/services/week';
import { compactNumber, formatDay } from '@/lib/format';

export const metadata = { title: 'Crew · HavuGym Crew' };

const METRIC_LABEL = {
  total_score: 'Total score',
  workout_count: 'Sessions logged',
  total_volume: 'Total volume',
} as const;

export default async function CrewPage() {
  const havura = await getActiveHavura();
  if (!havura) redirect('/onboarding');

  const weekStart = weekStartOf(new Date());

  // Lazy settlement: opening this page closes out any finished week that nobody
  // has settled yet. Both calls are idempotent — see src/lib/services/week.ts.
  await settleDueWeeks(havura.id);
  await ensureWeek(havura.id, weekStart);

  const [roster, stats] = await Promise.all([
    getCrewRoster(havura.id),
    getWeeklyStats(havura.id, weekStart),
  ]);

  const definition = challengeForWeek(weekStart);
  const metric = metricForWeek(weekStart);
  const byUser = new Map(stats.map((s) => [s.user_id!, s]));

  const value = (userId: string) => {
    const stat = byUser.get(userId);
    if (!stat) return 0;
    if (metric === 'total_score') return Number(stat.total_score ?? 0);
    if (metric === 'workout_count') return Number(stat.workout_count ?? 0);
    return Number(stat.total_volume ?? 0);
  };

  const entries: CompetitionEntry[] = roster.map((m) => ({ userId: m.user_id, value: value(m.user_id) }));
  // Projected standings, using the exact function that will settle for real on
  // Sunday — so what the crew watches all week is what actually pays out.
  const standings = settleCompetition(entries, COMPETITION_POT);
  const names = new Map(roster.map((m) => [m.user_id, m.profiles?.display_name ?? 'Unknown']));

  const challengeValue = (userId: string) => {
    const stat = byUser.get(userId);
    if (!stat) return 0;
    if (definition.kind === 'workout_count') return Number(stat.workout_count ?? 0);
    if (definition.kind === 'muscle_coverage') return Number(stat.muscles_hit ?? 0);
    return Number(stat.total_volume ?? 0);
  };

  return (
    <div className="space-y-5">
      <div>
        <h1 className="text-xl font-semibold tracking-tight">{havura.name}</h1>
        <p className="mt-1 text-sm text-muted">
          Week of {formatDay(`${weekStart}T12:00:00Z`)} – {formatDay(`${weekEndOf(weekStart)}T12:00:00Z`)}
          {' · '}{roster.length} member{roster.length === 1 ? '' : 's'}
        </p>
      </div>

      <InviteCode code={havura.inviteCode} />

      <section className="card" aria-labelledby="challenge">
        <div className="flex items-center gap-2 text-accent">
          <TargetIcon className="h-4 w-4" />
          <h2 id="challenge" className="text-xs font-semibold uppercase tracking-wide">
            This week&apos;s challenge
          </h2>
        </div>
        <p className="mt-2.5 text-sm font-medium">{definition.describe}</p>
        <p className="mt-1 text-xs text-muted">
          Everyone who reaches it earns {definition.rewardCreatine} creatine.
        </p>

        <ul className="mt-4 space-y-2.5">
          {roster.map((member) => {
            const current = challengeValue(member.user_id);
            const pct = Math.min(100, (current / definition.target) * 100);
            const done = current >= definition.target;
            return (
              <li key={member.user_id}>
                <div className="flex items-center justify-between text-sm">
                  <span className="flex items-center gap-1.5">
                    {member.profiles?.display_name}
                    {done && <CheckIcon className="h-3.5 w-3.5 text-good" />}
                  </span>
                  <span className="tabular text-muted">
                    {compactNumber(current)} / {compactNumber(definition.target)}
                  </span>
                </div>
                <div className="mt-1.5 h-1.5 overflow-hidden rounded-full bg-surface-2">
                  <div
                    className={`h-full rounded-full ${done ? 'bg-good' : 'bg-accent'}`}
                    style={{ width: `${pct}%` }}
                  />
                </div>
              </li>
            );
          })}
        </ul>
      </section>

      <section className="card" aria-labelledby="competition">
        <div className="flex items-center gap-2 text-accent">
          <TrophyIcon className="h-4 w-4" />
          <h2 id="competition" className="text-xs font-semibold uppercase tracking-wide">
            This week&apos;s competition
          </h2>
        </div>
        <p className="mt-2.5 text-sm font-medium">{METRIC_LABEL[metric]}</p>
        <p className="mt-1 text-xs text-muted">
          {COMPETITION_POT} creatine in the pot, split 70 / 20 / 10 when the week closes.
        </p>

        <ol className="mt-4 space-y-1">
          {standings.map((row) => (
            <li
              key={row.userId}
              className="flex items-center justify-between gap-3 rounded-lg px-2 py-2
                         odd:bg-surface-2/60"
            >
              <span className="flex min-w-0 items-center gap-3">
                <span className="w-5 shrink-0 text-sm tabular text-muted">{row.rank}</span>
                <span className="truncate text-sm">{names.get(row.userId)}</span>
              </span>
              <span className="flex shrink-0 items-center gap-3 text-sm">
                <span className="tabular text-muted">{compactNumber(row.value)}</span>
                {row.payout > 0 && (
                  <span className="tabular font-semibold text-accent">+{row.payout}</span>
                )}
              </span>
            </li>
          ))}
        </ol>
        <p className="mt-3 text-xs text-muted">
          Projected, using the same function that settles the real payout.
        </p>
      </section>
    </div>
  );
}
