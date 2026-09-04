import { redirect } from 'next/navigation';
import { DumbbellIcon } from '@/components/icons';
import { getMyHavuras, getProfile } from '@/lib/queries';
import { OnboardingForm } from './onboarding-form';

export const metadata = { title: 'Join a crew · HavuGym Crew' };

export default async function OnboardingPage() {
  const profile = await getProfile();
  if (!profile) redirect('/login');

  // Already in a crew: nothing to onboard.
  if ((await getMyHavuras()).length > 0) redirect('/feed');

  return (
    <main className="mx-auto flex min-h-dvh w-full max-w-md flex-col justify-center gap-7 px-5 py-12">
      <div>
        <DumbbellIcon className="h-6 w-6 text-accent" />
        <h1 className="mt-4 text-2xl font-semibold tracking-tight">
          Welcome, {profile.display_name}
        </h1>
        <p className="mt-2 text-sm leading-relaxed text-muted">
          HavuGym is built around a crew. Start one and invite your friends, or join
          one with the code somebody sent you.
        </p>
      </div>
      <OnboardingForm />
    </main>
  );
}
