'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { CrewIcon, FeedIcon, LogIcon, MeIcon, ShopIcon } from './icons';

const TABS = [
  { href: '/feed', label: 'Feed', Icon: FeedIcon },
  { href: '/crew', label: 'Crew', Icon: CrewIcon },
  { href: '/log', label: 'Log', Icon: LogIcon },
  { href: '/shop', label: 'Shop', Icon: ShopIcon },
  { href: '/me', label: 'Me', Icon: MeIcon },
] as const;

export function AppNav() {
  const pathname = usePathname();

  return (
    <nav
      aria-label="Primary"
      className="sticky bottom-0 z-20 border-t border-line bg-ink/95 backdrop-blur
                 sm:top-0 sm:bottom-auto sm:border-b sm:border-t-0"
    >
      <ul className="mx-auto flex max-w-2xl">
        {TABS.map(({ href, label, Icon }) => {
          const active = pathname === href || pathname.startsWith(`${href}/`);
          return (
            <li key={href} className="flex-1">
              <Link
                href={href}
                aria-current={active ? 'page' : undefined}
                className={`flex flex-col items-center gap-1 py-2.5 text-[11px] font-medium
                            transition-colors sm:flex-row sm:justify-center sm:gap-2 sm:py-3.5 sm:text-sm
                            ${active ? 'text-accent' : 'text-muted hover:text-text'}`}
              >
                <Icon className="h-5 w-5" />
                {label}
              </Link>
            </li>
          );
        })}
      </ul>
    </nav>
  );
}
