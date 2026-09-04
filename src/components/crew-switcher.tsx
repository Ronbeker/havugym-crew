'use client';

import { useTransition } from 'react';
import { useRouter } from 'next/navigation';
import { switchHavuraAction } from '@/lib/actions/havura';
import { CheckIcon } from './icons';
import type { HavuraMembership } from '@/lib/queries';

export function CrewSwitcher({
  memberships,
  activeId,
}: {
  memberships: HavuraMembership[];
  activeId: string;
}) {
  const [pending, start] = useTransition();
  const router = useRouter();

  return (
    <section className="card" aria-labelledby="crews">
      <h2 id="crews" className="text-xs font-semibold uppercase tracking-wide text-muted">
        Your crews
      </h2>
      <ul className="mt-3 divide-y divide-line">
        {memberships.map((membership) => (
          <li key={membership.id}>
            <button
              type="button"
              disabled={pending || membership.id === activeId}
              onClick={() =>
                start(async () => {
                  await switchHavuraAction(membership.id);
                  router.refresh();
                })
              }
              className="flex w-full items-center justify-between gap-3 py-2.5 text-left
                         disabled:cursor-default"
            >
              <span className="min-w-0">
                <span className="block truncate text-sm">{membership.name}</span>
                <span className="text-xs capitalize text-muted">{membership.role}</span>
              </span>
              {membership.id === activeId && <CheckIcon className="h-4 w-4 shrink-0 text-accent" />}
            </button>
          </li>
        ))}
      </ul>
    </section>
  );
}
