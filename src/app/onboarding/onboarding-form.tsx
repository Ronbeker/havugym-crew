'use client';

import { useActionState, useState } from 'react';
import { createHavuraAction, joinHavuraAction } from '@/lib/actions/havura';
import { FieldError, FormError, SubmitButton } from '@/components/form';
import type { ActionResult } from '@/lib/actions/result';

export function OnboardingForm() {
  const [mode, setMode] = useState<'create' | 'join'>('create');

  const [createState, create] = useActionState<ActionResult<string> | null, FormData>(
    createHavuraAction,
    null,
  );
  const [joinState, join] = useActionState<ActionResult<string> | null, FormData>(
    joinHavuraAction,
    null,
  );

  const state = mode === 'create' ? createState : joinState;
  const errors = state && !state.ok ? (state.fieldErrors ?? {}) : {};

  return (
    <div className="card space-y-5">
      <div className="grid grid-cols-2 gap-1 rounded-xl border border-line bg-surface-2 p-1">
        {([['create', 'Start a crew'], ['join', 'Join with a code']] as const).map(([m, label]) => (
          <button
            key={m}
            type="button"
            onClick={() => setMode(m)}
            className={`rounded-lg px-3 py-2 text-sm font-medium transition-colors ${
              mode === m ? 'bg-accent text-accent-ink' : 'text-muted hover:text-text'
            }`}
          >
            {label}
          </button>
        ))}
      </div>

      {mode === 'create' ? (
        <form action={create} className="space-y-4" noValidate>
          <div>
            <label className="label" htmlFor="name">Crew name</label>
            <input
              id="name"
              name="name"
              className="field"
              placeholder="Sunday Morning Club"
              maxLength={40}
              required
            />
            <FieldError message={errors.name} />
          </div>
          <FormError message={state && !state.ok ? state.error : undefined} />
          <SubmitButton pendingLabel="Creating…">Create crew</SubmitButton>
          <p className="text-xs leading-relaxed text-muted">
            You will get a six-character invite code to share with your friends.
          </p>
        </form>
      ) : (
        <form action={join} className="space-y-4" noValidate>
          <div>
            <label className="label" htmlFor="code">Invite code</label>
            <input
              id="code"
              name="code"
              className="field text-center text-lg font-semibold uppercase tracking-[0.3em]"
              placeholder="ABC123"
              maxLength={6}
              autoCapitalize="characters"
              required
            />
            <FieldError message={errors.code} />
          </div>
          <FormError message={state && !state.ok ? state.error : undefined} />
          <SubmitButton pendingLabel="Joining…">Join crew</SubmitButton>
        </form>
      )}
    </div>
  );
}
