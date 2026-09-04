import { redirect } from 'next/navigation';
import { getActiveHavura, getProfile, getScoringBaseline } from '@/lib/queries';
import { WorkoutLogger } from './workout-logger';

export const metadata = { title: 'Log a session · HavuGym Crew' };

export default async function LogPage() {
  const [profile, havura] = await Promise.all([getProfile(), getActiveHavura()]);
  if (!profile || !havura) redirect('/onboarding');

  // Sent to the client so the score preview can be computed without a round trip
  // on every keystroke. It is only volumes and durations — nothing sensitive.
  const priors = await getScoringBaseline(profile.id);

  return (
    <div className="space-y-5">
      <div>
        <h1 className="text-xl font-semibold tracking-tight">Log a session</h1>
        <p className="mt-1 text-sm text-muted">Posting to {havura.name}.</p>
      </div>
      <WorkoutLogger havuraId={havura.id} priors={priors} />
    </div>
  );
}
