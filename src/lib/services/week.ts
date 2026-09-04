import 'server-only';

import { createAdminClient } from '@/lib/supabase/admin';
import { challengeForWeek, isChallengeComplete } from '@/lib/domain/challenge';
import { settleCompetition, type CompetitionEntry } from '@/lib/domain/competition';
import { weekStartOf } from '@/lib/domain/time';
import type { Database } from '@/lib/database.types';

type CompetitionMetric = Database['public']['Enums']['competition_metric'];

/** Creatine put up for the weekly competition, split across the podium. */
export const COMPETITION_POT = 500;

const METRIC_ROTATION: readonly CompetitionMetric[] = [
  'total_score',
  'workout_count',
  'total_volume',
];

function hashString(value: string): number {
  let hash = 0x811c9dc5;
  for (let i = 0; i < value.length; i++) {
    hash ^= value.charCodeAt(i);
    hash = Math.imul(hash, 0x01000193) >>> 0;
  }
  return hash >>> 0;
}

/** Salted differently from the challenge so the two do not move in lockstep. */
export function metricForWeek(weekStart: string): CompetitionMetric {
  return METRIC_ROTATION[hashString(`competition:${weekStart}`) % METRIC_ROTATION.length];
}

/**
 * Creates this week's challenge and competition for a crew if they do not exist.
 *
 * Runs with the SERVICE ROLE, because `authenticated` has no INSERT privilege on
 * either table — a member must not be able to invent a challenge with a target
 * of 1 and a reward of 100,000. It is only ever reached from server code that
 * has already confirmed the caller's membership.
 *
 * Both tables carry UNIQUE (havura_id, week_start), so two members loading the
 * page at the same moment cannot create two competitions: the second insert
 * loses the race and is ignored.
 */
export async function ensureWeek(havuraId: string, weekStart: string) {
  const admin = createAdminClient();
  const definition = challengeForWeek(weekStart);

  await Promise.all([
    admin
      .from('challenges')
      .upsert(
        {
          havura_id: havuraId,
          week_start: weekStart,
          kind: definition.kind,
          target: definition.target,
          reward_creatine: definition.rewardCreatine,
        },
        { onConflict: 'havura_id,week_start', ignoreDuplicates: true },
      ),
    admin
      .from('competitions')
      .upsert(
        {
          havura_id: havuraId,
          week_start: weekStart,
          metric: metricForWeek(weekStart),
          pot_creatine: COMPETITION_POT,
        },
        { onConflict: 'havura_id,week_start', ignoreDuplicates: true },
      ),
  ]);

  const [{ data: challenge }, { data: competition }] = await Promise.all([
    admin
      .from('challenges')
      .select('*')
      .eq('havura_id', havuraId)
      .eq('week_start', weekStart)
      .single(),
    admin
      .from('competitions')
      .select('*')
      .eq('havura_id', havuraId)
      .eq('week_start', weekStart)
      .single(),
  ]);

  return { challenge, competition };
}

function metricValue(
  metric: CompetitionMetric,
  stat: { total_score: number | null; workout_count: number | null; total_volume: number | null },
): number {
  switch (metric) {
    case 'total_score':
      return Number(stat.total_score ?? 0);
    case 'workout_count':
      return Number(stat.workout_count ?? 0);
    case 'total_volume':
      return Number(stat.total_volume ?? 0);
  }
}

/**
 * Settles every finished, still-open week for a crew.
 *
 * This is invoked lazily when someone opens the crew page, rather than by a
 * scheduled job. That is a deliberate trade for a project this size and a stated
 * limitation in the scale document: a crew where nobody opens the app for three
 * weeks settles all three the moment somebody does. Correctness does not depend
 * on when it runs — only timeliness does.
 *
 * Safe to call repeatedly. Three independent guards:
 *   1. only competitions with status='open' and a week_start in the past are touched
 *   2. challenge rewards are gated on challenge_progress.paid_at
 *   3. every payment carries a ref, and the ledger's unique index rejects a replay
 */
export async function settleDueWeeks(havuraId: string, now = new Date()) {
  const admin = createAdminClient();
  const currentWeek = weekStartOf(now);

  const { data: due } = await admin
    .from('competitions')
    .select('*')
    .eq('havura_id', havuraId)
    .eq('status', 'open')
    .lt('week_start', currentWeek)
    .order('week_start', { ascending: true });

  if (!due || due.length === 0) return { settled: 0 };

  let settled = 0;

  for (const competition of due) {
    const { data: stats } = await admin
      .from('weekly_user_stats')
      .select('*')
      .eq('havura_id', havuraId)
      .eq('week_start', competition.week_start);

    const { data: members } = await admin
      .from('havura_members')
      .select('user_id')
      .eq('havura_id', havuraId);

    // Members with no sessions still get a row, at value 0, so the final table
    // shows the whole crew rather than only those who turned up.
    const byUser = new Map((stats ?? []).map((s) => [s.user_id!, s]));
    const entries: CompetitionEntry[] = (members ?? []).map((m) => ({
      userId: m.user_id,
      value: byUser.has(m.user_id)
        ? metricValue(competition.metric, byUser.get(m.user_id)!)
        : 0,
    }));

    const results = settleCompetition(entries, competition.pot_creatine);

    if (results.length > 0) {
      await admin.from('competition_results').upsert(
        results.map((r) => ({
          competition_id: competition.id,
          user_id: r.userId,
          rank: r.rank,
          value: r.value,
          payout: r.payout,
        })),
        { onConflict: 'competition_id,user_id' },
      );

      for (const result of results.filter((r) => r.payout > 0)) {
        await admin.rpc('apply_creatine', {
          p_user_id: result.userId,
          p_delta: result.payout,
          p_reason: 'competition_payout',
          p_ref_type: 'competition',
          p_ref_id: competition.id,
        });
      }
    }

    await admin
      .from('competitions')
      .update({ status: 'settled', settled_at: new Date().toISOString() })
      .eq('id', competition.id)
      .eq('status', 'open');

    await payChallengeRewards(havuraId, competition.week_start);
    settled += 1;
  }

  return { settled };
}

/** Pays everyone who met the week's cooperative target, once. */
async function payChallengeRewards(havuraId: string, weekStart: string) {
  const admin = createAdminClient();

  const { data: challenge } = await admin
    .from('challenges')
    .select('*')
    .eq('havura_id', havuraId)
    .eq('week_start', weekStart)
    .maybeSingle();

  if (!challenge) return;

  const { data: stats } = await admin
    .from('weekly_user_stats')
    .select('*')
    .eq('havura_id', havuraId)
    .eq('week_start', weekStart);

  for (const stat of stats ?? []) {
    if (!stat.user_id) continue;

    const workouts = [
      {
        volume: Number(stat.total_volume ?? 0),
        // muscles_hit is already the distinct count for the week; the domain
        // helper wants names, so a synthetic list of the right length is enough.
        musclesHit: Array.from({ length: stat.muscles_hit ?? 0 }, (_, i) => `m${i}`),
      },
    ];
    const repeated = Array.from({ length: stat.workout_count ?? 0 }, () => workouts[0]);
    const complete = isChallengeComplete(
      challenge.kind,
      challenge.target,
      challenge.kind === 'workout_count' ? repeated : workouts,
    );

    if (!complete) continue;

    const { data: existing } = await admin
      .from('challenge_progress')
      .select('paid_at')
      .eq('challenge_id', challenge.id)
      .eq('user_id', stat.user_id)
      .maybeSingle();

    if (existing?.paid_at) continue;

    await admin.rpc('apply_creatine', {
      p_user_id: stat.user_id,
      p_delta: challenge.reward_creatine,
      p_reason: 'challenge_reward',
      p_ref_type: 'challenge',
      p_ref_id: challenge.id,
    });

    await admin.from('challenge_progress').upsert(
      {
        challenge_id: challenge.id,
        user_id: stat.user_id,
        value: Number(stat.total_volume ?? 0),
        completed_at: new Date().toISOString(),
        paid_at: new Date().toISOString(),
      },
      { onConflict: 'challenge_id,user_id' },
    );
  }
}
