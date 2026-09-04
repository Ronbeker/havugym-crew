import { describe, expect, it } from 'vitest';
import {
  BODYWEIGHT_PROXY_KG, muscleCoverage, percentileCont, round2, scoreWorkout,
  setWork, workoutVolume, type ScoredSet,
} from '@/lib/domain/scoring';

const set = (over: Partial<ScoredSet> = {}): ScoredSet => ({
  reps: 10, weightKg: 50, equipment: 'barbell', musclePrimary: 'chest', ...over,
});

describe('setWork', () => {
  it('multiplies reps by load', () => {
    expect(setWork(set({ reps: 8, weightKg: 100 }))).toBe(800);
  });

  it('credits bodyweight movements with the nominal proxy load', () => {
    // A pull-up is not zero work. This is the documented approximation we make
    // because we do not collect bodyweight.
    expect(setWork(set({ reps: 10, weightKg: 0, equipment: 'bodyweight' })))
      .toBe(10 * BODYWEIGHT_PROXY_KG);
  });

  it('adds external load on top of the proxy for weighted bodyweight work', () => {
    expect(setWork(set({ reps: 5, weightKg: 20, equipment: 'bodyweight' })))
      .toBe(5 * (20 + BODYWEIGHT_PROXY_KG));
  });

  it('scores a non-bodyweight set at zero load as zero work', () => {
    // An empty-bar or unloaded machine set is real input, not a bug.
    expect(setWork(set({ weightKg: 0, equipment: 'machine' }))).toBe(0);
  });
});

describe('percentileCont', () => {
  it('returns null for no values', () => {
    expect(percentileCont([])).toBeNull();
  });

  it('returns the only value for a single sample', () => {
    expect(percentileCont([42])).toBe(42);
  });

  it('takes the middle of an odd-length sample', () => {
    expect(percentileCont([30, 10, 20])).toBe(20);
  });

  it('INTERPOLATES an even-length sample, matching Postgres percentile_cont', () => {
    // Not 20 and not 30 — this is the behaviour that keeps parity with the SQL.
    expect(percentileCont([10, 20, 30, 40])).toBe(25);
  });

  it('is order-independent', () => {
    expect(percentileCont([40, 10, 30, 20])).toBe(percentileCont([10, 20, 30, 40]));
  });
});

describe('round2', () => {
  it('rounds half away from zero, like Postgres numeric round()', () => {
    expect(round2(2.345)).toBe(2.35);
    expect(round2(2.344)).toBe(2.34);
  });

  it('leaves already-short values alone', () => {
    expect(round2(50)).toBe(50);
  });
});

describe('muscleCoverage', () => {
  it('counts distinct primary muscles, not sets', () => {
    expect(muscleCoverage([
      set({ musclePrimary: 'chest' }),
      set({ musclePrimary: 'chest' }),
      set({ musclePrimary: 'back' }),
    ])).toBe(2);
  });
});

describe('scoreWorkout', () => {
  const priors = [
    { volume: 6000, durationMin: 60 },
    { volume: 6000, durationMin: 60 },
    { volume: 6000, durationMin: 60 },
  ];

  it('scores a session at the athlete\'s own baseline at the midpoint of each component', () => {
    // Exactly the median volume and the median density: Load 25, Density 15.
    const result = scoreWorkout({
      sets: [set({ reps: 60, weightKg: 100, musclePrimary: 'chest' })], // 6000
      durationMin: 60,
      priors,
    });
    expect(result.load).toBe(25);
    expect(result.density).toBe(15);
    expect(result.coverage).toBe(4);
    expect(result.score).toBe(44);
  });

  it('caps the reward for a session far above baseline', () => {
    // Ten times the usual volume must not score ten times as high.
    const result = scoreWorkout({
      sets: [set({ reps: 600, weightKg: 100 })],
      durationMin: 60,
      priors,
    });
    expect(result.load).toBe(50);
    expect(result.density).toBe(30);
  });

  it('gives a neutral, non-flattering baseline for a first-ever session', () => {
    const result = scoreWorkout({ sets: [set()], durationMin: 60, priors: [] });
    expect(result.usedNeutralBaseline).toBe(true);
    expect(result.load).toBe(25);
    expect(result.density).toBe(15);
  });

  it('caps coverage so a scattergun session cannot farm it', () => {
    const sets = ['chest', 'back', 'legs', 'glutes', 'core', 'biceps', 'triceps']
      .map((musclePrimary) => set({ musclePrimary }));
    expect(scoreWorkout({ sets, durationMin: 60, priors }).coverage).toBe(20);
  });

  it('never exceeds 100 or drops below 0', () => {
    const huge = scoreWorkout({
      sets: ['chest', 'back', 'legs', 'core', 'biceps']
        .map((m) => set({ musclePrimary: m, reps: 100, weightKg: 300 })),
      durationMin: 1,
      priors,
    });
    expect(huge.score).toBeLessThanOrEqual(100);
    expect(huge.score).toBeGreaterThanOrEqual(0);
  });

  it('only uses the most recent eight sessions as the baseline', () => {
    // Nine priors: the trailing one is far heavier and must be ignored.
    const withOldOutlier = [...Array(8).fill({ volume: 1000, durationMin: 60 }),
      { volume: 999_999, durationMin: 60 }];
    const result = scoreWorkout({
      sets: [set({ reps: 20, weightKg: 50 })], // 1000
      durationMin: 60,
      priors: withOldOutlier,
    });
    expect(result.load).toBe(25);
  });

  it('is deterministic', () => {
    const input = { sets: [set()], durationMin: 45, priors };
    expect(scoreWorkout(input)).toEqual(scoreWorkout(input));
  });
});

describe('workoutVolume', () => {
  it('is zero for an empty session', () => {
    expect(workoutVolume([])).toBe(0);
  });
});
