'use client';

import { useActionState, useState } from 'react';
import { signInAction, signUpAction } from '@/lib/actions/auth';
import { FieldError, FormError, SubmitButton } from '@/components/form';
import type { ActionResult } from '@/lib/actions/result';

type Mode = 'signin' | 'signup';

export function LoginForm({ initialMode = 'signin' }: { initialMode?: Mode }) {
  const [mode, setMode] = useState<Mode>(initialMode);

  // Two separate action states so switching tabs does not carry one form's
  // errors over to the other.
  const [signInState, signIn] = useActionState<ActionResult<string> | null, FormData>(
    signInAction,
    null,
  );
  const [signUpState, signUp] = useActionState<ActionResult<string> | null, FormData>(
    signUpAction,
    null,
  );

  const state = mode === 'signin' ? signInState : signUpState;
  const errors = state && !state.ok ? (state.fieldErrors ?? {}) : {};
  const needsConfirmation = signUpState?.ok && signUpState.data === 'confirm-email';

  if (needsConfirmation) {
    return (
      <div className="card space-y-3">
        <h2 className="text-lg font-semibold">Check your email</h2>
        <p className="text-sm text-muted">
          We sent a confirmation link. Open it, then come back and sign in.
        </p>
        <button className="btn-ghost w-full" onClick={() => setMode('signin')}>
          Back to sign in
        </button>
      </div>
    );
  }

  return (
    <div className="card space-y-5">
      <div className="grid grid-cols-2 gap-1 rounded-xl border border-line bg-surface-2 p-1">
        {(['signin', 'signup'] as const).map((m) => (
          <button
            key={m}
            type="button"
            onClick={() => setMode(m)}
            className={`rounded-lg px-3 py-2 text-sm font-medium transition-colors ${
              mode === m ? 'bg-accent text-accent-ink' : 'text-muted hover:text-text'
            }`}
          >
            {m === 'signin' ? 'Sign in' : 'Create account'}
          </button>
        ))}
      </div>

      <form action={mode === 'signin' ? signIn : signUp} className="space-y-4" noValidate>
        {mode === 'signup' && (
          <div>
            <label className="label" htmlFor="displayName">Name</label>
            <input
              id="displayName"
              name="displayName"
              className="field"
              placeholder="How your crew sees you"
              autoComplete="name"
              required
            />
            <FieldError message={errors.displayName} />
          </div>
        )}

        <div>
          <label className="label" htmlFor="email">Email</label>
          <input
            id="email"
            name="email"
            type="email"
            className="field"
            placeholder="you@example.com"
            autoComplete="email"
            required
          />
          <FieldError message={errors.email} />
        </div>

        <div>
          <label className="label" htmlFor="password">Password</label>
          <input
            id="password"
            name="password"
            type="password"
            className="field"
            placeholder={mode === 'signup' ? 'At least 8 characters' : ''}
            autoComplete={mode === 'signup' ? 'new-password' : 'current-password'}
            required
          />
          <FieldError message={errors.password} />
        </div>

        <FormError message={state && !state.ok ? state.error : undefined} />

        <SubmitButton pendingLabel={mode === 'signin' ? 'Signing in…' : 'Creating…'}>
          {mode === 'signin' ? 'Sign in' : 'Create account'}
        </SubmitButton>
      </form>
    </div>
  );
}
