import Link from 'next/link';
import { redirect } from 'next/navigation';
import { WorkoutCard } from '@/components/workout-card';
import { LogIcon, TargetIcon } from '@/components/icons';
import {
  getActiveHavura, getCrewFeed, getMuscleTouches, getProfile, getWeeklyStats,
} from '@/lib/queries';
import { challengeForWeek, challengeProgress } from '@/lib/domain/challenge';
import { suggestNextSession } from '@/lib/domain/recommendation';
import { weekStartOf, GYM_TIMEZONE } from '@/lib/domain/time';

export const metadata = { title: 'Feed · HavuGym Crew' };

export default async function FeedPage({
  searchParams,
}: {
  searchParams: Promise<{ before?: string }>;
}) {
  const { before } = await searchParams;
  const [profile, havura] = await Promise.all([getProfile(), getActiveHavura()]);
  if (!profile || !havura) redirect('/onboarding');

  const weekStart = weekStartOf(new Date());
  const [{ rows, nextCursor }, touches, stats] = await Promise.all([
    getCrewFeed(havura.id, { before }),
    getMuscleTouches(profile.id),
    getWeeklyStats(havura.id, weekStart),
  ]);

  const definition = challengeForWeek(weekStart);
  const mine = stats.find((s) => s.user_id === profile.id);
  const progress = challengeProgress(definition.kind, [
    {
      volume: Number(mine?.total_volume ?? 0),
      musclesHit: Array.from({ length: mine?.muscles_hit ?? 0 }, (_, i) => `m${i}`),
    },
  ]);
  const countProgress = definition.kind === 'workout_count'
    ? (mine?.workout_count ?? 0)
    : progress;

  // 1 = Sunday, matching the week's own start day.
  const dayOfWeek =
    new Date(
      new Date().toLocaleString('en-US', { timeZone: GYM_TIMEZONE }),
    ).getDay() + 1;

  const recommendation = suggestNextSession({
    touches,
    challenge: {
      kind: definition.kind,
      target: definition.target,
      progress: countProgress,
      dayOfWeek,
    },
  });

  return (
    <div className="space-y-5">
      <div className="flex items-baseline justify-between">
        <h1 className="text-xl font-semibold tracking-tight">{havura.name}</h1>
        <Link href="/log" className="text-sm font-medium text-accent">Log a session</Link>
      </div>

      <section className="card" aria-labelledby="next-session">
        <div className="flex items-center gap-2 text-accent">
          <TargetIcon className="h-4 w-4" />
          <h2 id="next-session" className="text-xs font-semibold uppercase tracking-wide">
            Suggested next
          </h2>
        </div>
        <p className="mt-2.5 text-sm">
          Train <span className="font-semibold capitalize text-accent">{recommendation.muscle}</span>
          {recommendation.daysSinceTrained === null
            ? ' — you have not trained it in the last month.'
            : ` — last trained ${recommendation.daysSinceTrained} day${
                recommendation.daysSinceTrained === 1 ? '' : 's'
              } ago.`}
        </p>
        {recommendation.pace && (
          <p className="mt-1.5 text-sm text-muted">
            {definition.describe}: {Math.round(recommendation.pace.progress).toLocaleString()} of{' '}
            {recommendation.pace.target.toLocaleString()}.{' '}
            <span className={recommendation.pace.onTrack ? 'text-good' : 'text-danger'}>
              {recommendation.pace.onTrack ? 'On pace.' : 'Behind pace.'}
            </span>
          </p>
        )}
      </section>

      {rows.length === 0 ? (
        <div className="card text-center">
          <LogIcon className="mx-auto h-6 w-6 text-muted" />
          <p className="mt-3 text-sm font-medium">Nothing logged yet</p>
          <p className="mt-1 text-sm text-muted">
            The first session in a crew is the one that starts it.
          </p>
          <Link href="/log" className="btn-primary mt-4">Log the first one</Link>
        </div>
      ) : (
        <div className="space-y-3">
          {rows.map((row) => (
            <WorkoutCard key={row.id} row={row} />
          ))}
        </div>
      )}

      {nextCursor && (
        <Link
          href={`/feed?before=${encodeURIComponent(nextCursor)}`}
          className="btn-ghost w-full"
        >
          Older sessions
        </Link>
      )}
      {before && (
        <Link href="/feed" className="block text-center text-sm text-muted">
          Back to the top
        </Link>
      )}
    </div>
  );
}
