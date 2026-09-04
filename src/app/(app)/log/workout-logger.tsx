'use client';

import { useActionState, useMemo, useState, useTransition } from 'react';
import { useRouter } from 'next/navigation';
import { logWorkoutAction, searchExercisesAction } from '@/lib/actions/workout';
import { FormError, SubmitButton } from '@/components/form';
import { CloseIcon, LogIcon } from '@/components/icons';
import { scoreWorkout, type PriorWorkout, type ScoredSet } from '@/lib/domain/scoring';
import { compactNumber, scoreBand } from '@/lib/format';
import type { ActionResult } from '@/lib/actions/result';
import type { Exercise } from '@/lib/queries';

interface DraftSet {
  weightKg: string;
  reps: string;
}

interface DraftExercise {
  exercise: Exercise;
  sets: DraftSet[];
}

/** A blank set inherits the previous one, because sets repeat far more often
 *  than they change — this is the difference between four taps and sixteen. */
const nextSet = (previous?: DraftSet): DraftSet => ({
  weightKg: previous?.weightKg ?? '',
  reps: previous?.reps ?? '',
});

function toIsoLocal(date: Date): string {
  const pad = (n: number) => String(n).padStart(2, '0');
  return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())}T${pad(
    date.getHours(),
  )}:${pad(date.getMinutes())}`;
}

export function WorkoutLogger({
  havuraId,
  priors,
}: {
  havuraId: string;
  priors: PriorWorkout[];
}) {
  const router = useRouter();
  const [entries, setEntries] = useState<DraftExercise[]>([]);
  const [duration, setDuration] = useState('60');
  const [query, setQuery] = useState('');
  const [results, setResults] = useState<Exercise[]>([]);
  const [searching, startSearch] = useTransition();

  const [state, submit] = useActionState<ActionResult<string> | null, FormData>(
    async (prev, formData) => {
      const result = await logWorkoutAction(prev, formData);
      if (result?.ok) router.push(`/workouts/${result.data}`);
      return result;
    },
    null,
  );

  /**
   * Live score preview, computed with the same formula the database uses.
   * Cosmetic only — the stored score is whatever compute_workout_score() says.
   */
  const preview = useMemo(() => {
    const sets: ScoredSet[] = entries.flatMap((entry) =>
      entry.sets
        .filter((s) => s.reps !== '' && s.weightKg !== '')
        .map((s) => ({
          reps: Number(s.reps),
          weightKg: Number(s.weightKg),
          equipment: entry.exercise.equipment,
          musclePrimary: entry.exercise.muscle_primary,
        })),
    );
    if (sets.length === 0) return null;
    return scoreWorkout({ sets, durationMin: Math.max(Number(duration) || 1, 1), priors });
  }, [entries, duration, priors]);

  function runSearch(term: string) {
    setQuery(term);
    startSearch(async () => setResults(term.trim().length < 2 ? [] : await searchExercisesAction(term)));
  }

  function addExercise(exercise: Exercise) {
    setEntries((current) =>
      current.some((e) => e.exercise.id === exercise.id)
        ? current
        : [...current, { exercise, sets: [nextSet()] }],
    );
    setQuery('');
    setResults([]);
  }

  const update = (index: number, fn: (entry: DraftExercise) => DraftExercise) =>
    setEntries((current) => current.map((entry, i) => (i === index ? fn(entry) : entry)));

  /** Flattened into the shape logWorkoutSchema expects; set_index is per exercise. */
  const payload = entries.flatMap((entry) =>
    entry.sets
      .filter((s) => s.reps !== '' && s.weightKg !== '')
      .map((s, i) => ({
        exerciseId: entry.exercise.id,
        setIndex: i + 1,
        weightKg: Number(s.weightKg),
        reps: Number(s.reps),
        rpe: null,
      })),
  );

  return (
    <form action={submit} className="space-y-5" noValidate>
      <input type="hidden" name="havuraId" value={havuraId} />
      <input type="hidden" name="sets" value={JSON.stringify(payload)} />

      <div className="card space-y-4">
        <div>
          <label className="label" htmlFor="title">Session</label>
          <input
            id="title"
            name="title"
            className="field"
            placeholder="Push day"
            maxLength={60}
            required
            defaultValue=""
          />
        </div>

        <div className="grid grid-cols-2 gap-3">
          <div>
            <label className="label" htmlFor="performedAt">When</label>
            <input
              id="performedAt"
              name="performedAtLocal"
              type="datetime-local"
              className="field"
              defaultValue={toIsoLocal(new Date())}
              onChange={(e) => {
                const hidden = document.getElementById('performedAt-iso') as HTMLInputElement;
                if (hidden) hidden.value = new Date(e.target.value).toISOString();
              }}
            />
            {/* The server wants an absolute instant; datetime-local has no offset. */}
            <input
              id="performedAt-iso"
              type="hidden"
              name="performedAt"
              defaultValue={new Date().toISOString()}
            />
          </div>
          <div>
            <label className="label" htmlFor="durationMin">Minutes</label>
            <input
              id="durationMin"
              name="durationMin"
              type="number"
              inputMode="numeric"
              min={1}
              max={480}
              className="field tabular"
              value={duration}
              onChange={(e) => setDuration(e.target.value)}
              required
            />
          </div>
        </div>
      </div>

      <div className="card space-y-3">
        <label className="label" htmlFor="exercise-search">Add an exercise</label>
        <input
          id="exercise-search"
          className="field"
          placeholder="Search 660 exercises…"
          value={query}
          onChange={(e) => runSearch(e.target.value)}
          autoComplete="off"
        />
        {searching && <p className="text-xs text-muted">Searching…</p>}
        {results.length > 0 && (
          <ul className="max-h-64 divide-y divide-line overflow-y-auto rounded-xl border border-line">
            {results.map((exercise) => (
              <li key={exercise.id}>
                <button
                  type="button"
                  onClick={() => addExercise(exercise)}
                  className="flex w-full items-center justify-between gap-3 px-3.5 py-2.5 text-left
                             text-sm hover:bg-surface-2"
                >
                  <span className="truncate">{exercise.name}</span>
                  <span className="chip shrink-0 capitalize">{exercise.muscle_primary}</span>
                </button>
              </li>
            ))}
          </ul>
        )}
      </div>

      {entries.map((entry, index) => (
        <div key={entry.exercise.id} className="card space-y-3">
          <div className="flex items-start justify-between gap-3">
            <div className="min-w-0">
              <h3 className="truncate text-sm font-semibold">{entry.exercise.name}</h3>
              <p className="mt-0.5 text-xs capitalize text-muted">
                {entry.exercise.muscle_primary} · {entry.exercise.equipment.replace('_', ' ')}
              </p>
            </div>
            <button
              type="button"
              aria-label={`Remove ${entry.exercise.name}`}
              onClick={() => setEntries((c) => c.filter((_, i) => i !== index))}
              className="rounded-lg p-1.5 text-muted hover:text-danger"
            >
              <CloseIcon className="h-4 w-4" />
            </button>
          </div>

          <ul className="space-y-2">
            {entry.sets.map((set, setIndex) => (
              <li key={setIndex} className="flex items-center gap-2">
                <span className="w-6 shrink-0 text-xs tabular text-muted">{setIndex + 1}</span>
                <input
                  aria-label={`Set ${setIndex + 1} weight in kilograms`}
                  className="field tabular"
                  type="number"
                  inputMode="decimal"
                  min={0}
                  max={500}
                  step="0.5"
                  placeholder="kg"
                  value={set.weightKg}
                  onChange={(e) =>
                    update(index, (en) => ({
                      ...en,
                      sets: en.sets.map((s, i) =>
                        i === setIndex ? { ...s, weightKg: e.target.value } : s,
                      ),
                    }))
                  }
                />
                <input
                  aria-label={`Set ${setIndex + 1} repetitions`}
                  className="field tabular"
                  type="number"
                  inputMode="numeric"
                  min={1}
                  max={100}
                  placeholder="reps"
                  value={set.reps}
                  onChange={(e) =>
                    update(index, (en) => ({
                      ...en,
                      sets: en.sets.map((s, i) =>
                        i === setIndex ? { ...s, reps: e.target.value } : s,
                      ),
                    }))
                  }
                />
                {entry.sets.length > 1 && (
                  <button
                    type="button"
                    aria-label={`Remove set ${setIndex + 1}`}
                    onClick={() =>
                      update(index, (en) => ({
                        ...en,
                        sets: en.sets.filter((_, i) => i !== setIndex),
                      }))
                    }
                    className="rounded-lg p-1.5 text-muted hover:text-danger"
                  >
                    <CloseIcon className="h-4 w-4" />
                  </button>
                )}
              </li>
            ))}
          </ul>

          <button
            type="button"
            className="btn-ghost w-full"
            onClick={() =>
              update(index, (en) => ({
                ...en,
                sets: [...en.sets, nextSet(en.sets[en.sets.length - 1])],
              }))
            }
          >
            Add set
          </button>
        </div>
      ))}

      {preview && (
        <div className="card">
          <p className="text-xs font-semibold uppercase tracking-wide text-muted">
            Projected score
          </p>
          <div className="mt-2 flex items-end justify-between">
            <p className={`text-4xl font-semibold tabular ${scoreBand(preview.score).className}`}>
              {preview.score.toFixed(0)}
            </p>
            <dl className="flex gap-4 text-right text-xs text-muted">
              <div><dt>Load</dt><dd className="tabular text-text">{preview.load.toFixed(0)}</dd></div>
              <div><dt>Density</dt><dd className="tabular text-text">{preview.density.toFixed(0)}</dd></div>
              <div><dt>Coverage</dt><dd className="tabular text-text">{preview.coverage}</dd></div>
              <div><dt>Volume</dt><dd className="tabular text-text">{compactNumber(preview.volume)}</dd></div>
            </dl>
          </div>
          {preview.usedNeutralBaseline && (
            <p className="mt-2.5 text-xs text-muted">
              First session — scored against a neutral baseline. From the next one,
              this is measured against your own recent average.
            </p>
          )}
        </div>
      )}

      <FormError message={state && !state.ok ? state.error : undefined} />

      {payload.length === 0 ? (
        <div className="card text-center text-sm text-muted">
          <LogIcon className="mx-auto h-5 w-5" />
          <p className="mt-2">Add an exercise and fill in at least one set.</p>
        </div>
      ) : (
        <SubmitButton pendingLabel="Saving…">
          Save session · {payload.length} set{payload.length === 1 ? '' : 's'}
        </SubmitButton>
      )}
    </form>
  );
}
