/**
 * Arrivals — the prospective half of the product.
 *
 * Every other surface here is retrospective: a logged session is a report of
 * something already finished, and a feed of finished sessions is an INJUNCTIVE
 * norm ("you should train more"), which people are very good at ignoring.
 *
 * An arrival is a DESCRIPTIVE norm — "people like you are doing this right now" —
 * and descriptive norms are the ones that reliably move behaviour. It is the same
 * effect behind the well-known hotel result, where telling guests that most
 * guests reuse their towels outperformed every environmental appeal tried
 * against it. What matters is not the instruction; it is the evidence that your
 * reference group is already doing the thing.
 *
 * A crew of 3-10 people who know each other outside the app is close to the
 * ideal reference group for that effect: small enough that every name is
 * someone you actually know, and large enough that "three of them are there"
 * carries real weight.
 *
 * Two design consequences, both of which live in this file:
 *
 *   1. THE COUNT IS THE SIGNAL. One friend at the gym is a fact; three is a
 *      norm. The copy escalates with the number, because the number is the
 *      whole mechanism.
 *   2. IT HAS TO BE TRUE. A stale "at the gym" flag teaches the crew that the
 *      signal is noise, and once they learn that it can never be un-learned.
 *      Arrivals expire, and expiry is enforced in the database, not here.
 */
import type { Database } from '@/lib/database.types';

export type ArrivalStatus = Database['public']['Enums']['arrival_status'];

/** Chosen server-side from the status; mirrored here for display only. */
export const ARRIVAL_WINDOW_MINUTES: Record<ArrivalStatus, number> = {
  on_the_way: 45,
  training: 150,
};

export interface ActiveArrival {
  id: string;
  userId: string;
  displayName: string;
  status: ArrivalStatus;
  note: string | null;
  announcedAt: string;
  expiresAt: string;
}

export type HerdStrength = 'empty' | 'single' | 'pair' | 'crowd';

export interface HerdSignal {
  /** Crewmates currently out — excludes the viewer. */
  others: ActiveArrival[];
  count: number;
  strength: HerdStrength;
  /** Whether the viewer has an arrival of their own open. */
  viewerIsOut: boolean;
  headline: string;
  subline: string;
}

export function minutesRemaining(expiresAt: string, now: Date = new Date()): number {
  return Math.max(0, Math.round((new Date(expiresAt).getTime() - now.getTime()) / 60_000));
}

export function isActive(arrival: { expiresAt: string }, now: Date = new Date()): boolean {
  return new Date(arrival.expiresAt).getTime() > now.getTime();
}

/** "Dana", "Dana and Itay", "Dana, Itay and 2 others". */
export function nameList(names: readonly string[]): string {
  if (names.length === 0) return '';
  if (names.length === 1) return names[0];
  if (names.length === 2) return `${names[0]} and ${names[1]}`;
  return `${names[0]}, ${names[1]} and ${names.length - 2} other${names.length === 3 ? '' : 's'}`;
}

function strengthFor(count: number): HerdStrength {
  if (count === 0) return 'empty';
  if (count === 1) return 'single';
  if (count === 2) return 'pair';
  return 'crowd';
}

/**
 * Turns the raw list into the thing a member actually reads.
 *
 * The escalation is deliberate and is the feature: one name is information,
 * three names is pressure. The wording is never an instruction — it reports what
 * the crew is doing and lets that do the work.
 */
export function herdSignal(
  arrivals: readonly ActiveArrival[],
  viewerId: string,
  now: Date = new Date(),
): HerdSignal {
  const live = arrivals.filter((a) => isActive(a, now));
  const viewerIsOut = live.some((a) => a.userId === viewerId);
  const others = live
    .filter((a) => a.userId !== viewerId)
    .sort((a, b) => a.announcedAt.localeCompare(b.announcedAt));

  const training = others.filter((a) => a.status === 'training');
  const onTheWay = others.filter((a) => a.status === 'on_the_way');
  const count = others.length;
  const strength = strengthFor(count);

  if (count === 0) {
    return {
      others,
      count,
      strength,
      viewerIsOut,
      headline: viewerIsOut ? 'You are the only one out' : 'Nobody is at the gym',
      subline: viewerIsOut
        ? 'Your crew can see you. That is usually enough to pull someone else out.'
        : 'Be the first. The crew sees it the moment you go.',
    };
  }

  // Present the stronger fact first: people already there outrank people intending to.
  const names = [...training, ...onTheWay].map((a) => a.displayName);

  const headline =
    strength === 'crowd'
      ? `${count} of your crew are out right now`
      : `${nameList(names)} ${count === 1 ? 'is' : 'are'} out right now`;

  const subline =
    training.length > 0 && onTheWay.length > 0
      ? `${nameList(training.map((a) => a.displayName))} at the gym, ${nameList(onTheWay.map((a) => a.displayName))} on the way.`
      : training.length > 0
        ? strength === 'crowd'
          ? 'That is most of the crew. Today is the easy day to go.'
          : 'Training right now.'
        : 'On the way. You could still get there first.';

  return { others, count, strength, viewerIsOut, headline, subline };
}
