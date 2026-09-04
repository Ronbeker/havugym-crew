import Link from 'next/link';
import { redirect } from 'next/navigation';
import { getSessionUser } from '@/lib/supabase/server';
import { CreatineIcon, DumbbellIcon, TargetIcon, TrophyIcon } from '@/components/icons';

const FEATURES = [
  {
    Icon: DumbbellIcon,
    title: 'One shared log',
    body: 'Every session your crew trains lands in the same feed, scored the moment it is saved.',
  },
  {
    Icon: TargetIcon,
    title: 'A weekly challenge',
    body: 'A cooperative goal each week. Everyone who reaches it gets paid, so the crew pulls together.',
  },
  {
    Icon: TrophyIcon,
    title: 'A weekly competition',
    body: 'One ranking, one pot, settled every Sunday and split across the podium.',
  },
  {
    Icon: CreatineIcon,
    title: 'Creatine',
    body: 'The currency you earn by training. Spend it on titles and badges — never on an advantage.',
  },
];

export default async function LandingPage() {
  if (await getSessionUser()) redirect('/feed');

  return (
    <main className="mx-auto w-full max-w-3xl px-5 py-16 sm:py-24">
      <div className="flex items-center gap-2.5">
        <DumbbellIcon className="h-6 w-6 text-accent" />
        <span className="text-lg font-semibold tracking-tight">HavuGym Crew</span>
      </div>

      <h1 className="mt-12 max-w-xl text-4xl font-semibold leading-tight tracking-tight sm:text-5xl">
        Training alone is optional.
        <span className="block text-accent">Being seen is not.</span>
      </h1>

      <p className="mt-5 max-w-lg text-base leading-relaxed text-muted">
        A private shared gym log for you and your friends. Log a session, and it is
        scored against your own recent baseline — so the beginner and the veteran
        compete on the same scale.
      </p>

      <div className="mt-8 flex flex-wrap gap-3">
        <Link href="/login" className="btn-primary">Start a crew</Link>
        <Link href="/login" className="btn-ghost">I have an invite code</Link>
      </div>

      <div className="mt-16 grid gap-4 sm:grid-cols-2">
        {FEATURES.map(({ Icon, title, body }) => (
          <div key={title} className="card">
            <Icon className="h-5 w-5 text-accent" />
            <h2 className="mt-3 text-sm font-semibold">{title}</h2>
            <p className="mt-1.5 text-sm leading-relaxed text-muted">{body}</p>
          </div>
        ))}
      </div>
    </main>
  );
}
