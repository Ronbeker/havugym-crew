import { redirect } from 'next/navigation';
import { signOutAction } from '@/lib/actions/auth';
import { CreatineIcon } from '@/components/icons';
import { CrewSwitcher } from '@/components/crew-switcher';
import {
  getActiveHavura, getCrewFeed, getMyHavuras, getProfile, getWallet,
} from '@/lib/queries';
import { compactNumber, relativeDay } from '@/lib/format';

export const metadata = { title: 'Profile · HavuGym Crew' };

const LEDGER_LABEL: Record<string, string> = {
  signup_bonus: 'Welcome bonus',
  challenge_reward: 'Weekly challenge',
  competition_payout: 'Competition payout',
  shop_purchase: 'Shop purchase',
  pack_purchase: 'Creatine pack',
  admin_adjust: 'Adjustment',
};

export default async function MePage() {
  const [profile, memberships, havura, wallet] = await Promise.all([
    getProfile(), getMyHavuras(), getActiveHavura(), getWallet(),
  ]);
  if (!profile || !havura) redirect('/onboarding');

  const { rows } = await getCrewFeed(havura.id, { limit: 50 });
  const mine = rows.filter((row) => row.user_id === profile.id);

  const sessions = mine.length;
  const totalVolume = mine.reduce((sum, row) => sum + Number(row.volume ?? 0), 0);
  const averageScore = sessions
    ? mine.reduce((sum, row) => sum + Number(row.score ?? 0), 0) / sessions
    : 0;

  return (
    <div className="space-y-5">
      <div>
        <h1 className="text-xl font-semibold tracking-tight">{profile.display_name}</h1>
        <p className="mt-1 flex items-center gap-1.5 text-sm text-muted">
          <CreatineIcon className="h-4 w-4 text-accent" />
          <span className="tabular">{profile.creatine_balance.toLocaleString()} creatine</span>
        </p>
      </div>

      <section className="card grid grid-cols-3 gap-3" aria-label="Your statistics">
        <div>
          <p className="text-[11px] uppercase tracking-wide text-muted">Sessions</p>
          <p className="mt-1 text-xl font-semibold tabular">{sessions}</p>
        </div>
        <div>
          <p className="text-[11px] uppercase tracking-wide text-muted">Volume</p>
          <p className="mt-1 text-xl font-semibold tabular">{compactNumber(totalVolume)}</p>
        </div>
        <div>
          <p className="text-[11px] uppercase tracking-wide text-muted">Avg score</p>
          <p className="mt-1 text-xl font-semibold tabular">{averageScore.toFixed(0)}</p>
        </div>
      </section>

      <CrewSwitcher memberships={memberships} activeId={havura.id} />

      <section className="card" aria-labelledby="ledger">
        <h2 id="ledger" className="text-xs font-semibold uppercase tracking-wide text-muted">
          Creatine ledger
        </h2>
        <p className="mt-1 text-xs text-muted">
          Every change to your balance, in order. This is the record; the number
          at the top of the screen is a cache of it.
        </p>

        {wallet.ledger.length === 0 ? (
          <p className="mt-3 text-sm text-muted">No movements yet.</p>
        ) : (
          <ul className="mt-3 divide-y divide-line">
            {wallet.ledger.map((entry) => (
              <li key={entry.id} className="flex items-center justify-between gap-4 py-2.5">
                <div className="min-w-0">
                  <p className="truncate text-sm">{LEDGER_LABEL[entry.reason] ?? entry.reason}</p>
                  <p className="text-xs text-muted">{relativeDay(entry.created_at)}</p>
                </div>
                <div className="shrink-0 text-right">
                  <p className={`text-sm font-semibold tabular ${entry.delta > 0 ? 'text-good' : 'text-danger'}`}>
                    {entry.delta > 0 ? '+' : ''}{entry.delta.toLocaleString()}
                  </p>
                  <p className="text-xs tabular text-muted">{entry.balance_after.toLocaleString()}</p>
                </div>
              </li>
            ))}
          </ul>
        )}
      </section>

      <form action={signOutAction}>
        <button type="submit" className="btn-ghost w-full">Sign out</button>
      </form>
    </div>
  );
}
