import type { ChallengeKind } from './challenge';

/**
 * "What should I train next?" — the recommendation surface the brief asks for
 * (קבלת המלצות).
 *
 * Deliberately not a model. It is two readable rules over the athlete's own
 * recent history, which means it can be explained in one sentence, tested
 * exhaustively, and never produces a suggestion we cannot justify:
 *
 *   1. Train the primary muscle group you have neglected longest.
 *   2. Tell the athlete whether they are on pace for the weekly challenge, using
 *      elapsed days rather than a flat target, so Tuesday and Friday give
 *      different advice.
 */

/** The eight primary muscle groups a session can be built around. */
export const PRIMARY_MUSCLES = [
  'chest', 'back', 'shoulders', 'legs', 'glutes', 'core', 'biceps', 'triceps',
] as const;

export type PrimaryMuscle = (typeof PRIMARY_MUSCLES)[number];

export interface MuscleTouch {
  muscle: string;
  /** Days since that muscle was last trained; null when never. */
  daysAgo: number | null;
}

export interface Recommendation {
  muscle: PrimaryMuscle;
  daysSinceTrained: number | null;
  pace: {
    kind: ChallengeKind;
    progress: number;
    target: number;
    /** Where they should be by now, given how much of the week has elapsed. */
    expected: number;
    onTrack: boolean;
  } | null;
}

/**
 * Picks the longest-neglected muscle. Never-trained beats any number of days,
 * and ties break on the fixed PRIMARY_MUSCLES order so the answer is stable
 * rather than dependent on object key order.
 */
export function neglectedMuscle(touches: readonly MuscleTouch[]): PrimaryMuscle {
  const byMuscle = new Map(touches.map((t) => [t.muscle, t.daysAgo]));

  let best: PrimaryMuscle = PRIMARY_MUSCLES[0];
  let bestScore = -1;

  for (const muscle of PRIMARY_MUSCLES) {
    const daysAgo = byMuscle.has(muscle) ? byMuscle.get(muscle)! : null;
    const score = daysAgo === null ? Number.POSITIVE_INFINITY : daysAgo;
    if (score > bestScore) {
      bestScore = score;
      best = muscle;
    }
  }

  return best;
}

export function suggestNextSession(input: {
  touches: readonly MuscleTouch[];
  challenge?: {
    kind: ChallengeKind;
    target: number;
    progress: number;
    /** 1 = Sunday (first day of the week) … 7 = Saturday. */
    dayOfWeek: number;
  };
}): Recommendation {
  const muscle = neglectedMuscle(input.touches);
  const touch = input.touches.find((t) => t.muscle === muscle);

  let pace: Recommendation['pace'] = null;
  if (input.challenge) {
    const { kind, target, progress, dayOfWeek } = input.challenge;
    const elapsed = Math.min(Math.max(dayOfWeek, 1), 7) / 7;
    const expected = target * elapsed;
    pace = { kind, progress, target, expected, onTrack: progress >= expected };
  }

  return {
    muscle,
    daysSinceTrained: touch ? touch.daysAgo : null,
    pace,
  };
}
