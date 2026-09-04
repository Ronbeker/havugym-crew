'use client';

import { useFormStatus } from 'react-dom';
import { SpinnerIcon } from './icons';

/**
 * A submit button that reflects the pending state of its own form.
 *
 * useFormStatus reads the status of the nearest enclosing <form>, which is why
 * this has to be its own component rather than a prop on the page — the hook
 * returns nothing when called from the component that renders the form.
 */
export function SubmitButton({
  children,
  pendingLabel,
  className = 'btn-primary w-full',
}: {
  children: React.ReactNode;
  pendingLabel?: string;
  className?: string;
}) {
  const { pending } = useFormStatus();
  return (
    <button type="submit" className={className} disabled={pending}>
      {pending && <SpinnerIcon />}
      {pending ? (pendingLabel ?? 'Working…') : children}
    </button>
  );
}

export function FieldError({ message }: { message?: string }) {
  if (!message) return null;
  return <p className="mt-1.5 text-xs text-danger">{message}</p>;
}

export function FormError({ message }: { message?: string }) {
  if (!message) return null;
  return (
    <div
      role="alert"
      className="rounded-xl border border-danger/40 bg-danger/10 px-3.5 py-2.5 text-sm text-danger"
    >
      {message}
    </div>
  );
}
