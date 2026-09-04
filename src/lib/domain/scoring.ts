/**
 * The intensity score, 0..100 — TypeScript mirror of public.compute_workout_score.
 *
 * The DATABASE is authoritative: log_workout() computes the stored score, so a
 * client can never award itself a 100. This module exists to show the athlete
 * what a session will score *before* they save it, and — more importantly — to
 * make the formula unit-testable, which plpgsql is not.
 *
 * tests/scoring.parity.test.ts asserts the two implementations agree on a fixed
 * set of fixtures, run against the real database. If someone edits one and not
 * the other, that test fails.
 *
 * Why relative-to-self rather than absolute load: a shared crew leaderboard
 * between a beginner and a five-year lifter is meaningless if it measures
 * kilograms. Measuring each session against that athlete's own recent baseline
 * means both of them score ~50 for a normal day and ~90 for a brutal one, which
 * is the only version of the number that makes the crew competition fair.
 */

/** Bodyweight movements carry no external load; a pull-up is not zero work. */
export const BODYWEIGHT_PROXY_KG = 30;

/** Component ceilings. They sum to 100 by construction. */
export const LOAD_MAX = 50;
export const DENSITY_MAX = 30;
export const COVERAGE_MAX = 20;
export const COVERAGE_PER_MUSCLE = 4;

/** How far above your own baseline still earns more credit. */
export const RATIO_CAP = 2;

/** How many previous sessions form the baseline. */
export const BASELINE_WINDOW = 8;

export interface ScoredSet {
  reps: number;
  weightKg: number;
  /** exercises.equipment */
  equipment: string;
  /** exercises.muscle_primary */
  musclePrimary: string;
}

export interface PriorWorkout {
  volume: number;
  durationMin: number;
}

export interface ScoreBreakdown {
  score: number;
  load: number;
  density: number;
  coverage: number;
  volume: number;
  /** True when there was no usable history and the ratios defaulted to 1. */
  usedNeutralBaseline: boolean;
}

/** Work done by one set, in kilogram-reps. */
export function setWork(set: ScoredSet): number {
  const proxy = set.equipment === 'bodyweight' ? BODYWEIGHT_PROXY_KG : 0;
  return set.reps * (set.weightKg + proxy);
}

export function workoutVolume(sets: readonly ScoredSet[]): number {
  return sets.reduce((total, set) => total + setWork(set), 0);
}

export function muscleCoverage(sets: readonly ScoredSet[]): number {
  return new Set(sets.map((s) => s.musclePrimary)).size;
}

/**
 * Linear-interpolated median, matching Postgres percentile_cont(0.5).
 *
 * Not the same as "the middle element": for an even-length input Postgres
 * interpolates between the two central values, so [10,20,30,40] is 25, not 20 or
 * 30. Getting this wrong is the easiest way to break parity with the SQL.
 */
export function percentileCont(values: readonly number[], p = 0.5): number | null {
  if (values.length === 0) return null;
  const sorted = [...values].sort((a, b) => a - b);
  if (sorted.length === 1) return sorted[0];

  const position = p * (sorted.length - 1);
  const lower = Math.floor(position);
  const upper = Math.ceil(position);
  if (lower === upper) return sorted[lower];
  return sorted[lower] + (sorted[upper] - sorted[lower]) * (position - lower);
}

/** Postgres numeric round() is half-away-from-zero, unlike Math.round on negatives. */
export function round2(n: number): number {
  const scaled = Math.abs(n) * 100;
  const rounded = Math.round(scaled + Number.EPSILON);
  return (Math.sign(n) * rounded) / 100;
}

const clamp = (n: number, lo: number, hi: number) => Math.min(Math.max(n, lo), hi);

export function scoreWorkout(input: {
  sets: readonly ScoredSet[];
  durationMin: number;
  /** The athlete's previous sessions, most recent first. Only the first 8 count. */
  priors: readonly PriorWorkout[];
}): ScoreBreakdown {
  const { sets, durationMin } = input;
  const priors = input.priors.slice(0, BASELINE_WINDOW);

  const volume = workoutVolume(sets);
  const coverageCount = muscleCoverage(sets);

  const priorVolumes = priors.map((p) => p.volume);
  const priorDensities = priors
    .filter((p) => p.durationMin > 0)
    .map((p) => p.volume / p.durationMin);

  const medianVolume = percentileCont(priorVolumes);
  const medianDensity = percentileCont(priorDensities);

  const haveVolumeBaseline = medianVolume !== null && medianVolume > 0;
  const haveDensityBaseline = medianDensity !== null && medianDensity > 0;

  // Half of each component's ceiling is the "exactly at your own baseline" value.
  const load = haveVolumeBaseline
    ? (LOAD_MAX / RATIO_CAP) * Math.min(volume / medianVolume, RATIO_CAP)
    : LOAD_MAX / RATIO_CAP;

  const density = haveDensityBaseline
    ? (DENSITY_MAX / RATIO_CAP) * Math.min(volume / durationMin / medianDensity, RATIO_CAP)
    : DENSITY_MAX / RATIO_CAP;

  const coverage = Math.min(coverageCount * COVERAGE_PER_MUSCLE, COVERAGE_MAX);

  return {
    score: round2(clamp(load + density + coverage, 0, 100)),
    load: round2(load),
    density: round2(density),
    coverage,
    volume: round2(volume),
    usedNeutralBaseline: !haveVolumeBaseline && !haveDensityBaseline,
  };
}
