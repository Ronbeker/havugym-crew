import { getShopState, getWallet } from '@/lib/queries';
import { CREATINE_PACKS, formatPrice, packRate, paymentsConfigured } from '@/lib/packs';
import { CreatineIcon } from '@/components/icons';
import { ItemButton } from './shop-actions';
import { BuyPackButton } from './buy-pack';

export const metadata = { title: 'Shop · HavuGym Crew' };

const SECTIONS = [
  { kind: 'title', heading: 'Titles', blurb: 'Shown next to your name on every card.' },
  { kind: 'badge', heading: 'Badges', blurb: 'A mark on your profile.' },
  { kind: 'theme', heading: 'Themes', blurb: 'Colour schemes for the app.' },
] as const;

export default async function ShopPage() {
  const [{ items, owned }, wallet] = await Promise.all([getShopState(), getWallet(0)]);

  return (
    <div className="space-y-5">
      <div className="flex items-baseline justify-between">
        <h1 className="text-xl font-semibold tracking-tight">Shop</h1>
        <p className="flex items-center gap-1.5 text-sm font-semibold tabular">
          <CreatineIcon className="h-4 w-4 text-accent" />
          {wallet.balance.toLocaleString()}
        </p>
      </div>

      <p className="text-sm leading-relaxed text-muted">
        Everything here is cosmetic. Creatine buys a title, a badge or a theme —
        never a scoring advantage, and never a place on the leaderboard.
      </p>

      {paymentsConfigured() && (
        <section className="card" aria-labelledby="packs">
          <h2 id="packs" className="text-xs font-semibold uppercase tracking-wide text-muted">
            Top up
          </h2>
          <ul className="mt-3 space-y-2.5">
            {CREATINE_PACKS.map((pack) => (
              <li key={pack.slug} className="flex items-center justify-between gap-4">
                <div className="min-w-0">
                  <p className="text-sm font-medium">
                    {pack.name} · {pack.creatine.toLocaleString()} creatine
                  </p>
                  <p className="text-xs text-muted tabular">
                    {formatPrice(pack)} · {packRate(pack).toLocaleString()} per ₪
                  </p>
                </div>
                <BuyPackButton slug={pack.slug} label={formatPrice(pack)} />
              </li>
            ))}
          </ul>
        </section>
      )}

      {SECTIONS.map((section) => {
        const sectionItems = items.filter((item) => item.kind === section.kind);
        if (sectionItems.length === 0) return null;

        return (
          <section key={section.kind} className="card" aria-labelledby={section.kind}>
            <h2 id={section.kind} className="text-xs font-semibold uppercase tracking-wide text-muted">
              {section.heading}
            </h2>
            <p className="mt-1 text-xs text-muted">{section.blurb}</p>

            <ul className="mt-3.5 divide-y divide-line">
              {sectionItems.map((item) => {
                const isOwned = owned.has(item.id);
                return (
                  <li key={item.id} className="flex items-center justify-between gap-4 py-3">
                    <div className="min-w-0">
                      <p className="truncate text-sm font-medium">{item.name}</p>
                      <p className="text-xs tabular text-muted">
                        {isOwned ? 'Owned' : `${item.price_creatine.toLocaleString()} creatine`}
                      </p>
                    </div>
                    <ItemButton
                      itemId={item.id}
                      owned={isOwned}
                      equipped={owned.get(item.id) === true}
                      price={item.price_creatine}
                      affordable={wallet.balance >= item.price_creatine}
                    />
                  </li>
                );
              })}
            </ul>
          </section>
        );
      })}
    </div>
  );
}
