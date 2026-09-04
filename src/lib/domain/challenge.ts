import type { Database } from '@/lib/database.types';

/**
 * The weekly crew challenge — a cooperative goal, as opposed to the competition,
 * which is a ranking. Every member who reaches the target is paid the same
 * reward, so the challenge encourages a crew to drag its quiet members along
 * rather than to beat them.
 *
 * The week's challenge is DERIVED from the week, not stored randomly: the same
 * week always produces the same challenge. That makes it reproducible in tests
 * and means a crew created mid-week sees the same challenge as everyone else,
 * with no seeding job to run.
 */
export type ChallengeKind = Database['public']['Enums']['challenge_kind'];

export interface ChallengeDefinition {
  kind: ChallengeKind;
  target: number;
  rewardCreatine: number;
  /** English label; the UI supplies its own copy. */
  describe: string;
}

const ROTATION: readonly ChallengeDefinition[] = [
  {
    kind: 'workout_count',
    target: 3,
    rewardCreatine: 250,
    describe: 'Log 3 workouts this week',
  },
  {
    kind: 'total_volume',
    target: 20_000,
    rewardCreatine: 300,
    describe: 'Move 20,000 kg-reps of total volume this week',
  },
  {
    kind: 'muscle_coverage',
    target: 6,
    rewardCreatine: 275,
    describe: 'Train 6 different muscle groups this week',
  },
];

/** FNV-1a. Small, stable, and dependency-free — we need repeatable, not secure. */
function hashString(value: string): number {
  let hash = 0x811c9dc5;
  for (let i = 0; i < value.length; i++) {
    hash ^= value.charCodeAt(i);
    hash = Math.imul(hash, 0x01000193) >>> 0;
  }
  return hash >>> 0;
}

export function challengeForWeek(weekStart: string): ChallengeDefinition {
  return ROTATION[hashString(weekStart) % ROTATION.length];
}

export interface WeeklyWorkout {
  volume: number;
  musclesHit: readonly string[];
}

/** How far one athlete has got toward this week's target. */
export function challengeProgress(
  kind: ChallengeKind,
  workouts: readonly WeeklyWorkout[],
): number {
  switch (kind) {
    case 'workout_count':
      return workouts.length;
    case 'total_volume':
      return workouts.reduce((total, w) => total + w.volume, 0);
    case 'muscle_coverage':
      return new Set(workouts.flatMap((w) => w.musclesHit)).size;
  }
}

export function isChallengeComplete(
  kind: ChallengeKind,
  target: number,
  workouts: readonly WeeklyWorkout[],
): boolean {
  return challengeProgress(kind, workouts) >= target;
}
