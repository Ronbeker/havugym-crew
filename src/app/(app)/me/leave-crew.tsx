'use client';

import { leaveHavuraAction } from '@/lib/actions/havura';
import { DestructiveButton } from '@/components/destructive-button';

export function LeaveCrew({ havuraId, name, isOwner }: { havuraId: string; name: string; isOwner: boolean }) {
  if (isOwner) {
    return (
      <p className="text-xs leading-relaxed text-muted">
        You own {name}. Ownership has to move to another member before you can leave —
        otherwise the crew is left without one.
      </p>
    );
  }

  return (
    <DestructiveButton
      label={`Leave ${name}`}
      confirmLabel="Leave for good?"
      pendingLabel="Leaving…"
      action={() => leaveHavuraAction(havuraId)}
      redirectTo="/feed"
    />
  );
}
