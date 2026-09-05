import { describe, expect, it } from 'vitest';
import {
  challengeForWeek, challengeProgress, isChallengeComplete, progressFromWeeklyStat,
} from '@/lib/domain/challenge';

describe('challengeForWeek', () => {
  it('is deterministic — the same week always yields the same challenge', () => {
    expect(challengeForWeek('2026-08-30')).toEqual(challengeForWeek('2026-08-30'));
  });

  it('varies across weeks rather than always picking one kind', () => {
    const weeks = ['2026-08-02', '2026-08-09', '2026-08-16', '2026-08-23',
                   '2026-08-30', '2026-09-06', '2026-09-13', '2026-09-20'];
    const kinds = new Set(weeks.map((w) => challengeForWeek(w).kind));
    expect(kinds.size).toBeGreaterThan(1);
  });

  it('always produces a positive target and reward', () => {
    for (const week of ['2026-01-04', '2026-06-07', '2026-12-27']) {
      const definition = challengeForWeek(week);
      expect(definition.target).toBeGreaterThan(0);
      expect(definition.rewardCreatine).toBeGreaterThan(0);
    }
  });
});

describe('challengeProgress', () => {
  const workouts = [
    { volume: 5000, musclesHit: ['chest', 'triceps'] },
    { volume: 7000, musclesHit: ['back', 'chest'] },
  ];

  it('counts sessions for workout_count', () => {
    expect(challengeProgress('workout_count', workouts)).toBe(2);
  });

  it('sums volume for total_volume', () => {
    expect(challengeProgress('total_volume', workouts)).toBe(12_000);
  });

  it('counts DISTINCT muscles for muscle_coverage, not repeats', () => {
    expect(challengeProgress('muscle_coverage', workouts)).toBe(3);
  });

  it('is zero for no workouts', () => {
    expect(challengeProgress('total_volume', [])).toBe(0);
    expect(challengeProgress('muscle_coverage', [])).toBe(0);
  });
});

describe('isChallengeComplete', () => {
  const workouts = [{ volume: 20_000, musclesHit: ['chest'] }];

  it('completes on exactly hitting the target', () => {
    expect(isChallengeComplete('total_volume', 20_000, workouts)).toBe(true);
  });

  it('does not complete one unit short', () => {
    expect(isChallengeComplete('total_volume', 20_001, workouts)).toBe(false);
  });
});

describe('progressFromWeeklyStat', () => {
  const stat = { workout_count: 4, total_volume: 18_500, muscles_hit: 5 };

  it('reads the count for workout_count', () => {
    expect(progressFromWeeklyStat('workout_count', stat)).toBe(4);
  });

  it('reads the volume for total_volume', () => {
    expect(progressFromWeeklyStat('total_volume', stat)).toBe(18_500);
  });

  it('reads the distinct muscle count for muscle_coverage', () => {
    expect(progressFromWeeklyStat('muscle_coverage', stat)).toBe(5);
  });

  it('is zero for a member with no row this week', () => {
    expect(progressFromWeeklyStat('workout_count', undefined)).toBe(0);
    expect(progressFromWeeklyStat('total_volume', undefined)).toBe(0);
  });

  it('coerces the numeric column, which arrives as a string over the wire', () => {
    // Postgres numeric is serialised as a string by PostgREST; comparing that
    // against a target with >= would compare a string to a number.
    expect(progressFromWeeklyStat('total_volume', {
      workout_count: 1, total_volume: '20000', muscles_hit: 2,
    })).toBe(20_000);
  });

  it('treats nulls as zero rather than NaN', () => {
    expect(progressFromWeeklyStat('muscle_coverage', {
      workout_count: null, total_volume: null, muscles_hit: null,
    })).toBe(0);
  });
});
