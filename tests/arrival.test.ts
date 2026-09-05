import { describe, expect, it } from 'vitest';
import {
  herdSignal, isActive, minutesRemaining, nameList, type ActiveArrival,
} from '@/lib/domain/arrival';

const NOW = new Date('2026-09-05T18:00:00Z');
const inMinutes = (n: number) => new Date(NOW.getTime() + n * 60_000).toISOString();

const arrival = (over: Partial<ActiveArrival> & { userId: string }): ActiveArrival => ({
  id: `a-${over.userId}`,
  displayName: over.userId,
  status: 'training',
  note: null,
  announcedAt: '2026-09-05T17:50:00Z',
  expiresAt: inMinutes(90),
  ...over,
});

describe('minutesRemaining', () => {
  it('rounds to whole minutes', () => {
    expect(minutesRemaining(inMinutes(42), NOW)).toBe(42);
  });

  it('never goes negative for an expired arrival', () => {
    expect(minutesRemaining(inMinutes(-30), NOW)).toBe(0);
  });
});

describe('isActive', () => {
  it('is true while the window is open', () => {
    expect(isActive({ expiresAt: inMinutes(1) }, NOW)).toBe(true);
  });

  it('is false once it has passed', () => {
    expect(isActive({ expiresAt: inMinutes(-1) }, NOW)).toBe(false);
  });
});

describe('nameList', () => {
  it('renders one, two and many differently', () => {
    expect(nameList(['Dana'])).toBe('Dana');
    expect(nameList(['Dana', 'Itay'])).toBe('Dana and Itay');
    expect(nameList(['Dana', 'Itay', 'Maya'])).toBe('Dana, Itay and 1 other');
    expect(nameList(['Dana', 'Itay', 'Maya', 'Noam'])).toBe('Dana, Itay and 2 others');
  });

  it('is empty for nobody', () => {
    expect(nameList([])).toBe('');
  });
});

describe('herdSignal', () => {
  it('excludes the viewer from the count — the herd is other people', () => {
    const signal = herdSignal([arrival({ userId: 'me' })], 'me', NOW);
    expect(signal.count).toBe(0);
    expect(signal.viewerIsOut).toBe(true);
  });

  it('drops arrivals whose window has closed', () => {
    const signal = herdSignal(
      [arrival({ userId: 'Dana', expiresAt: inMinutes(-5) }), arrival({ userId: 'Itay' })],
      'me', NOW,
    );
    expect(signal.count).toBe(1);
    expect(signal.others[0].displayName).toBe('Itay');
  });

  it('escalates strength with the number of people', () => {
    const at = (n: number) => herdSignal(
      Array.from({ length: n }, (_, i) => arrival({ userId: `p${i}` })), 'me', NOW,
    ).strength;
    expect(at(0)).toBe('empty');
    expect(at(1)).toBe('single');
    expect(at(2)).toBe('pair');
    expect(at(3)).toBe('crowd');
    expect(at(7)).toBe('crowd');
  });

  it('names people while the list is short and counts them once it is not', () => {
    const two = herdSignal(
      [arrival({ userId: 'Dana' }), arrival({ userId: 'Itay' })], 'me', NOW);
    expect(two.headline).toContain('Dana and Itay');

    const many = herdSignal(
      ['Dana', 'Itay', 'Maya', 'Noam'].map((userId) => arrival({ userId })), 'me', NOW);
    // Past a couple of names the COUNT is the message, not the roll call.
    expect(many.headline).toBe('4 of your crew are out right now');
  });

  it('puts people already there ahead of people intending to go', () => {
    const signal = herdSignal([
      arrival({ userId: 'OnWay', status: 'on_the_way', announcedAt: '2026-09-05T17:40:00Z' }),
      arrival({ userId: 'There', status: 'training', announcedAt: '2026-09-05T17:55:00Z' }),
    ], 'me', NOW);
    // 'There' is at the gym and announced later; being there outranks intending.
    expect(signal.headline).toContain('There and OnWay');
  });

  it('describes a mixed crew in the subline', () => {
    const signal = herdSignal([
      arrival({ userId: 'Dana', status: 'training' }),
      arrival({ userId: 'Itay', status: 'on_the_way' }),
    ], 'me', NOW);
    expect(signal.subline).toContain('Dana at the gym');
    expect(signal.subline).toContain('Itay on the way');
  });

  it('invites the first mover when the gym is empty', () => {
    const signal = herdSignal([], 'me', NOW);
    expect(signal.strength).toBe('empty');
    expect(signal.headline).toBe('Nobody is at the gym');
    expect(signal.subline).toContain('Be the first');
  });

  it('tells a lone member that being visible is itself the mechanism', () => {
    const signal = herdSignal([arrival({ userId: 'me' })], 'me', NOW);
    expect(signal.headline).toBe('You are the only one out');
    expect(signal.subline).toContain('pull someone else out');
  });

  it('is deterministic for the same input', () => {
    const input = [arrival({ userId: 'Dana' }), arrival({ userId: 'Itay' })];
    expect(herdSignal(input, 'me', NOW)).toEqual(herdSignal(input, 'me', NOW));
  });
});
