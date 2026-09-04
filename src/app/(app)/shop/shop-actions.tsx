'use client';

import { useState, useTransition } from 'react';
import { equipAction, purchaseAction } from '@/lib/actions/shop';
import { CheckIcon, SpinnerIcon } from '@/components/icons';

export function ItemButton({
  itemId,
  owned,
  equipped,
  price,
  affordable,
}: {
  itemId: number;
  owned: boolean;
  equipped: boolean;
  price: number;
  affordable: boolean;
}) {
  const [pending, start] = useTransition();
  const [error, setError] = useState<string | null>(null);

  const run = (fn: () => Promise<{ ok: boolean; error?: string }>) =>
    start(async () => {
      setError(null);
      const result = await fn();
      if (!result.ok) setError(result.error ?? 'Something went wrong.');
    });

  if (equipped) {
    return (
      <span className="btn-ghost pointer-events-none text-good">
        <CheckIcon className="h-4 w-4" /> Equipped
      </span>
    );
  }

  return (
    <div className="flex flex-col items-end gap-1">
      <button
        type="button"
        disabled={pending || (!owned && !affordable)}
        onClick={() => run(() => (owned ? equipAction(itemId) : purchaseAction(itemId)))}
        className={owned ? 'btn-ghost' : 'btn-primary'}
      >
        {pending && <SpinnerIcon />}
        {owned ? 'Equip' : `${price.toLocaleString()}`}
      </button>
      {error && <span className="text-xs text-danger">{error}</span>}
    </div>
  );
}
