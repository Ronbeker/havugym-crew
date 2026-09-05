'use client';

import { useEffect, useState, useTransition } from 'react';
import { useRouter } from 'next/navigation';
import { announceArrivalAction, closeArrivalAction } from '@/lib/actions/arrival';
import { ArrivalIcon, SpinnerIcon, WalkIcon } from '@/components/icons';
import type { HerdSignal } from '@/lib/domain/arrival';

/** How often the banner re-reads the crew. See the note below on why not Realtime. */
const POLL_MS = 60_000;

export interface ArrivalView {
  id: string;
  displayName: string;
  status: 'on_the_way' | 'training';
  note: string | null;
  minutesLeft: number;
  isViewer: boolean;
}

/**
 * The prospective surface: who is at the gym right now.
 *
 * The whole signal — headline, subline, escalation — is computed on the SERVER
 * and passed down finished. Recomputing it here would mean calling `new Date()`
 * during render, which produces a different string on the server than in the
 * browser and a hydration mismatch on a component whose entire job is to be
 * trusted.
 *
 * It polls rather than subscribing to Realtime. A websocket would be more
 * elegant and is the wrong trade here: it is another connection, another
 * failure mode and another thing to reason about in the security document, in
 * exchange for latency nobody can perceive. For a crew of ten deciding whether
 * to go to the gym, a minute is not late.
 */
export function ArrivalBanner({
  signal,
  arrivals,
  havuraId,
}: {
  signal: HerdSignal;
  arrivals: ArrivalView[];
  havuraId: string;
}) {
  const router = useRouter();
  const [pending, start] = useTransition();
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const id = setInterval(() => router.refresh(), POLL_MS);
    return () => clearInterval(id);
  }, [router]);

  const run = (action: () => Promise<{ ok: boolean; error?: string }>) =>
    start(async () => {
      setError(null);
      const result = await action();
      if (!result.ok) setError(result.error ?? 'Something went wrong.');
      else router.refresh();
    });

  // A crowd earns emphasis; one person does not. The visual weight tracks the
  // strength of the signal for the same reason the copy does.
  const emphasised = signal.strength === 'crowd' || signal.strength === 'pair';

  return (
    <section
      aria-labelledby="arrivals"
      className={`card ${emphasised ? 'border-accent/50 bg-accent/[0.04]' : ''}`}
    >
      <div className="flex items-center gap-2 text-accent">
        <ArrivalIcon className="h-4 w-4" />
        <h2 id="arrivals" className="text-xs font-semibold uppercase tracking-wide">
          Right now
        </h2>
      </div>

      <p className={`mt-2.5 font-semibold ${emphasised ? 'text-lg' : 'text-sm'}`}>
        {signal.headline}
      </p>
      <p className="mt-1 text-sm leading-relaxed text-muted">{signal.subline}</p>

      {arrivals.length > 0 && (
        <ul className="mt-3.5 space-y-2 border-t border-line pt-3.5">
          {arrivals.map((arrival) => (
            <li key={arrival.id} className="flex items-start justify-between gap-3 text-sm">
              <span className="flex min-w-0 items-center gap-2">
                {arrival.status === 'on_the_way'
                  ? <WalkIcon className="h-4 w-4 shrink-0 text-muted" />
                  : <ArrivalIcon className="h-4 w-4 shrink-0 text-accent" />}
                <span className="min-w-0">
                  <span className="font-medium">
                    {arrival.displayName}{arrival.isViewer ? ' (you)' : ''}
                  </span>
                  <span className="text-muted">
                    {arrival.status === 'on_the_way' ? ' is on the way' : ' is at the gym'}
                  </span>
                  {arrival.note && (
                    <span className="block truncate text-xs text-muted">“{arrival.note}”</span>
                  )}
                </span>
              </span>
              <span className="shrink-0 text-xs tabular text-muted">{arrival.minutesLeft}m</span>
            </li>
          ))}
        </ul>
      )}

      <div className="mt-4 flex flex-wrap gap-2">
        {signal.viewerIsOut ? (
          <button
            type="button"
            className="btn-ghost"
            disabled={pending}
            onClick={() => run(() => closeArrivalAction(havuraId))}
          >
            {pending && <SpinnerIcon />}
            I&apos;m done
          </button>
        ) : (
          <>
            <button
              type="button"
              className="btn-primary"
              disabled={pending}
              onClick={() => run(() => announceArrivalAction(havuraId, 'training'))}
            >
              {pending && <SpinnerIcon />}
              I&apos;m at the gym
            </button>
            <button
              type="button"
              className="btn-ghost"
              disabled={pending}
              onClick={() => run(() => announceArrivalAction(havuraId, 'on_the_way'))}
            >
              On my way
            </button>
          </>
        )}
      </div>

      {error && <p className="mt-2 text-xs text-danger">{error}</p>}
    </section>
  );
}
