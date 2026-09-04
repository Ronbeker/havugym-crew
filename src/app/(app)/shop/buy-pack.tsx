'use client';

import { useState, useTransition } from 'react';
import { SpinnerIcon } from '@/components/icons';
import { startCheckoutAction } from '@/lib/actions/checkout';

export function BuyPackButton({ slug, label }: { slug: string; label: string }) {
  const [pending, start] = useTransition();
  const [error, setError] = useState<string | null>(null);

  return (
    <div className="flex flex-col items-end gap-1">
      <button
        type="button"
        disabled={pending}
        className="btn-primary"
        onClick={() =>
          start(async () => {
            setError(null);
            const result = await startCheckoutAction(slug);
            // Stripe hosts the payment page: card details never touch our origin,
            // which is why this app has no PCI surface to speak of.
            if (result.ok) window.location.assign(result.data);
            else setError(result.error);
          })
        }
      >
        {pending && <SpinnerIcon />}
        {label}
      </button>
      {error && <span className="text-xs text-danger">{error}</span>}
    </div>
  );
}
