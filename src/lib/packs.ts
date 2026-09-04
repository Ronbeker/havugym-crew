/**
 * Real-money creatine packs.
 *
 * Prices live in code rather than the database because Stripe is the source of
 * truth for what was actually charged: we create a Checkout Session with these
 * amounts, and the webhook credits based on what Stripe reports it collected,
 * not on what the browser claimed. A price in a table would just be a second
 * number to keep in sync.
 *
 * Amounts are in agorot (ILS minor units). Larger packs carry a better rate,
 * which is the entire commercial mechanic.
 */
export interface CreatinePack {
  slug: string;
  name: string;
  creatine: number;
  amountCents: number;
  currency: 'ils';
}

export const CREATINE_PACKS: readonly CreatinePack[] = [
  { slug: 'scoop',  name: 'Scoop',  creatine: 1_000,  amountCents: 990,  currency: 'ils' },
  { slug: 'tub',    name: 'Tub',    creatine: 5_500,  amountCents: 3_990, currency: 'ils' },
  { slug: 'bucket', name: 'Bucket', creatine: 15_000, amountCents: 8_990, currency: 'ils' },
];

export const packBySlug = (slug: string): CreatinePack | undefined =>
  CREATINE_PACKS.find((pack) => pack.slug === slug);

/** Creatine per shekel — shown so the better value is legible, not implied. */
export const packRate = (pack: CreatinePack): number =>
  Math.round(pack.creatine / (pack.amountCents / 100));

export const formatPrice = (pack: CreatinePack): string =>
  new Intl.NumberFormat('he-IL', { style: 'currency', currency: 'ILS', minimumFractionDigits: 2 })
    .format(pack.amountCents / 100);

/** Payments are optional: without keys the shop still works, minus the packs. */
export const paymentsConfigured = (): boolean =>
  Boolean(process.env.STRIPE_SECRET_KEY && process.env.NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY);
