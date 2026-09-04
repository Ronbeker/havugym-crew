import Link from 'next/link';
import { notFound } from 'next/navigation';
import { getWorkoutDetail } from '@/lib/queries';
import { compactNumber, formatDay, formatTime, scoreBand } from '@/lib/format';

export const metadata = { title: 'Session · HavuGym Crew' };

export default async function WorkoutPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  const detail = await getWorkoutDetail(id);

  // Not found and not permitted are the same response on purpose: a 403 would
  // confirm that a session with this id exists in somebody else's crew.
  if (!detail) notFound();

  const { workout, sets } = detail;
  const score = Number(workout.score ?? 0);
  const band = scoreBand(score);

  // Sets arrive ordered by index; grouping preserves the order they were logged.
  const byExercise = new Map<number, { name: string; muscle: string; sets: typeof sets }>();
  for (const set of sets) {
    const exercise = set.exercises;
    if (!exercise) continue;
    const existing = byExercise.get(exercise.id);
    if (existing) existing.sets.push(set);
    else byExercise.set(exercise.id, {
      name: exercise.name,
      muscle: exercise.muscle_primary,
      sets: [set],
    });
  }

  return (
    <div className="space-y-5">
      <Link href="/feed" className="text-sm text-muted hover:text-text">← Back to feed</Link>

      <div className="card">
        <div className="flex items-start justify-between gap-4">
          <div className="min-w-0">
            <p className="text-sm font-semibold">{workout.display_name}</p>
            <h1 className="mt-0.5 truncate text-lg font-semibold tracking-tight">{workout.title}</h1>
            <p className="mt-1 text-xs text-muted">
              {formatDay(workout.performed_at!)} · {formatTime(workout.performed_at!)} ·{' '}
              {workout.duration_min} min
            </p>
          </div>
          <div className="shrink-0 text-right">
            <p className={`text-3xl font-semibold tabular ${band.className}`}>{score.toFixed(0)}</p>
            <p className="text-[11px] uppercase tracking-wide text-muted">{band.label}</p>
          </div>
        </div>

        {workout.notes && (
          <p className="mt-3.5 border-t border-line pt-3.5 text-sm text-muted">{workout.notes}</p>
        )}

        <dl className="mt-4 grid grid-cols-3 gap-3 border-t border-line pt-4 text-sm">
          <div>
            <dt className="text-[11px] uppercase tracking-wide text-muted">Sets</dt>
            <dd className="tabular font-medium">{workout.set_count ?? 0}</dd>
          </div>
          <div>
            <dt className="text-[11px] uppercase tracking-wide text-muted">Volume</dt>
            <dd className="tabular font-medium">{compactNumber(Number(workout.volume ?? 0))}</dd>
          </div>
          <div>
            <dt className="text-[11px] uppercase tracking-wide text-muted">Muscles</dt>
            <dd className="tabular font-medium">{(workout.muscles ?? []).length}</dd>
          </div>
        </dl>
      </div>

      {[...byExercise.entries()].map(([exerciseId, group]) => (
        <section key={exerciseId} className="card">
          <div className="flex items-center justify-between gap-3">
            <h2 className="truncate text-sm font-semibold">{group.name}</h2>
            <span className="chip shrink-0 capitalize">{group.muscle}</span>
          </div>
          <table className="mt-3 w-full text-sm">
            <thead>
              <tr className="text-left text-[11px] uppercase tracking-wide text-muted">
                <th className="w-10 font-medium">Set</th>
                <th className="font-medium">Weight</th>
                <th className="font-medium">Reps</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-line">
              {group.sets.map((set) => (
                <tr key={set.set_index} className="tabular">
                  <td className="py-2 text-muted">{set.set_index}</td>
                  <td className="py-2">{Number(set.weight_kg)} kg</td>
                  <td className="py-2">{set.reps}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </section>
      ))}
    </div>
  );
}
