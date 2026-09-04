'use client';

import { useState } from 'react';
import { CheckIcon } from './icons';

export function InviteCode({ code }: { code: string }) {
  const [copied, setCopied] = useState(false);

  async function copy() {
    try {
      await navigator.clipboard.writeText(code);
      setCopied(true);
      setTimeout(() => setCopied(false), 1800);
    } catch {
      // Clipboard is unavailable over plain HTTP and in some embedded browsers.
      // The code is displayed in full either way, so there is nothing to recover.
    }
  }

  return (
    <div className="card flex items-center justify-between gap-4">
      <div>
        <p className="text-xs font-semibold uppercase tracking-wide text-muted">Invite code</p>
        <p className="mt-1.5 text-2xl font-semibold tracking-[0.35em] tabular">{code}</p>
      </div>
      <button type="button" onClick={copy} className="btn-ghost shrink-0">
        {copied ? <><CheckIcon className="h-4 w-4 text-good" /> Copied</> : 'Copy'}
      </button>
    </div>
  );
}
