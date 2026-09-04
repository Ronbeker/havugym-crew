import Link from 'next/link';
import { compactNumber, relativeDay, formatTime, scoreBand } from '@/lib/format';
import type { FeedRow } from '@/lib/queries';

export function WorkoutCard({ row, showAuthor = true }: { row: FeedRow; showAuthor?: boolean }) {
  const score = Number(row.score ?? 0);
  const band = scoreBand(score);
  const muscles = row.muscles ?? [];

  return (
    <Link
      href={`/workouts/${row.id}`}
      className="card block transition-colors hover:border-muted/40"
    >
      <div className="flex items-start justify-between gap-4">
        <div className="min-w-0">
          {showAuthor && (
            <p className="truncate text-sm font-semibold">{row.display_name}</p>
          )}
          <h3 className="truncate text-sm text-muted">{row.title}</h3>
        </div>
        <div className="shrink-0 text-right">
          <p className={`text-2xl font-semibold tabular ${band.className}`}>
            {score.toFixed(0)}
          </p>
          <p className="text-[11px] uppercase tracking-wide text-muted">{band.label}</p>
        </div>
      </div>

      <dl className="mt-4 grid grid-cols-3 gap-3 text-sm">
        <div>
          <dt className="text-[11px] uppercase tracking-wide text-muted">Sets</dt>
          <dd className="tabular font-medium">{row.set_count ?? 0}</dd>
        </div>
        <div>
          <dt className="text-[11px] uppercase tracking-wide text-muted">Volume</dt>
          <dd className="tabular font-medium">{compactNumber(Number(row.volume ?? 0))}</dd>
        </div>
        <div>
          <dt className="text-[11px] uppercase tracking-wide text-muted">Time</dt>
          <dd className="tabular font-medium">{row.duration_min} min</dd>
        </div>
      </dl>

      {muscles.length > 0 && (
        <ul className="mt-3.5 flex flex-wrap gap-1.5">
          {muscles.map((muscle) => (
            <li key={muscle} className="chip capitalize">{muscle}</li>
          ))}
        </ul>
      )}

      <p className="mt-3.5 text-xs text-muted">
        {relativeDay(row.performed_at!)} · {formatTime(row.performed_at!)}
      </p>
    </Link>
  );
}
