'use client';

import { useState, useTransition } from 'react';
import { useRouter } from 'next/navigation';
import { SpinnerIcon } from './icons';
import type { ActionResult } from '@/lib/actions/result';

/**
 * A destructive action behind a two-step confirmation.
 *
 * Deliberately not `window.confirm`: it is blocked in some embedded browsers,
 * cannot be styled, and is invisible to the end-to-end tests. Arming in place
 * keeps the confirmation inside the page, and inside the test.
 *
 * The armed state resets after six seconds so a stray first click cannot leave a
 * live delete button sitting under someone's thumb.
 */
export function DestructiveButton({
  label,
  confirmLabel,
  pendingLabel,
  action,
  redirectTo,
  className = 'btn-danger',
}: {
  label: string;
  confirmLabel: string;
  pendingLabel: string;
  action: () => Promise<ActionResult<unknown>>;
  redirectTo?: string;
  className?: string;
}) {
  const [armed, setArmed] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [pending, start] = useTransition();
  const router = useRouter();

  function arm() {
    setArmed(true);
    setError(null);
    setTimeout(() => setArmed(false), 6000);
  }

  function run() {
    start(async () => {
      const result = await action();
      if (!result.ok) {
        setError(result.error);
        setArmed(false);
        return;
      }
      if (redirectTo) router.push(redirectTo);
      else router.refresh();
    });
  }

  return (
    <div className="flex flex-col items-stretch gap-1.5">
      <button
        type="button"
        className={className}
        disabled={pending}
        onClick={armed ? run : arm}
      >
        {pending && <SpinnerIcon />}
        {pending ? pendingLabel : armed ? confirmLabel : label}
      </button>
      {error && <span className="text-xs text-danger">{error}</span>}
    </div>
  );
}
