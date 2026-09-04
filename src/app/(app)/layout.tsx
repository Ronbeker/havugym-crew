import { redirect } from 'next/navigation';
import { AppNav } from '@/components/app-nav';
import { getMyHavuras, getProfile } from '@/lib/queries';
import { CreatineIcon, DumbbellIcon } from '@/components/icons';

/**
 * Shell for every signed-in route.
 *
 * The membership check here is routing, not security: a member of no crew has
 * nothing to look at, so we send them to onboarding. Someone who skips this
 * layout entirely still sees nothing, because RLS returns no rows for a crew
 * they do not belong to.
 */
export default async function AppLayout({ children }: { children: React.ReactNode }) {
  const [profile, memberships] = await Promise.all([getProfile(), getMyHavuras()]);

  if (!profile) redirect('/login');
  if (memberships.length === 0) redirect('/onboarding');

  return (
    <div className="flex min-h-dvh flex-col sm:flex-col-reverse sm:justify-end">
      <header className="border-b border-line px-5 py-3.5 sm:border-b-0 sm:border-t">
        <div className="mx-auto flex max-w-2xl items-center justify-between">
          <div className="flex items-center gap-2">
            <DumbbellIcon className="h-5 w-5 text-accent" />
            <span className="text-sm font-semibold tracking-tight">HavuGym Crew</span>
          </div>
          <div className="flex items-center gap-1.5 text-sm font-semibold tabular">
            <CreatineIcon className="h-4 w-4 text-accent" />
            {profile.creatine_balance.toLocaleString()}
          </div>
        </div>
      </header>

      <main className="mx-auto w-full max-w-2xl flex-1 px-5 py-6">{children}</main>

      <AppNav />
    </div>
  );
}
