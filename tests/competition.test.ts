import { describe, expect, it } from 'vitest';
import { PODIUM_SHARES, settleCompetition } from '@/lib/domain/competition';

const entry = (userId: string, value: number) => ({ userId, value });
const payouts = (rows: { payout: number }[]) => rows.reduce((s, r) => s + r.payout, 0);

describe('settleCompetition', () => {
  it('splits a clean podium 70 / 20 / 10', () => {
    const results = settleCompetition(
      [entry('a', 100), entry('b', 80), entry('c', 60)], 500,
    );
    expect(results.map((r) => r.payout)).toEqual([350, 100, 50]);
    expect(PODIUM_SHARES).toEqual([0.7, 0.2, 0.1]);
  });

  it('pays out EXACTLY the pot, never a unit more or less', () => {
    // 333 does not divide cleanly by 70/20/10; largest-remainder must still close.
    for (const pot of [333, 1, 7, 999, 1_000_000]) {
      const results = settleCompetition(
        [entry('a', 9), entry('b', 6), entry('c', 3)], pot,
      );
      expect(payouts(results)).toBe(pot);
    }
  });

  it('ranks with standard competition ranking — a tie for first makes the next third', () => {
    const results = settleCompetition(
      [entry('a', 100), entry('b', 100), entry('c', 50)], 500,
    );
    expect(results.map((r) => r.rank)).toEqual([1, 1, 3]);
  });

  it('pools and splits the shares of tied positions', () => {
    // Two tied for first occupy positions 1 and 2, so they share 0.7 + 0.2.
    const results = settleCompetition(
      [entry('a', 100), entry('b', 100), entry('c', 50)], 500,
    );
    expect(results[0].payout).toBe(225);
    expect(results[1].payout).toBe(225);
    expect(results[2].payout).toBe(50);
    expect(payouts(results)).toBe(500);
  });

  it('gives the whole pot to a lone participant rather than stranding 30%', () => {
    const results = settleCompetition([entry('a', 10)], 500);
    expect(results[0].payout).toBe(500);
  });

  it('redistributes the unclaimed share when only two people train', () => {
    const results = settleCompetition([entry('a', 10), entry('b', 5)], 500);
    expect(payouts(results)).toBe(500);
    expect(results[0].payout).toBeGreaterThan(results[1].payout);
  });

  it('ranks non-participants but never pays them', () => {
    const results = settleCompetition(
      [entry('a', 10), entry('b', 0), entry('c', 0)], 500,
    );
    expect(results.find((r) => r.userId === 'b')!.payout).toBe(0);
    expect(results.find((r) => r.userId === 'c')!.payout).toBe(0);
    expect(payouts(results)).toBe(500);
  });

  it('pays nobody when nobody trained', () => {
    const results = settleCompetition([entry('a', 0), entry('b', 0)], 500);
    expect(payouts(results)).toBe(0);
    expect(results).toHaveLength(2);
  });

  it('handles an empty crew', () => {
    expect(settleCompetition([], 500)).toEqual([]);
  });

  it('pays nothing from an empty pot', () => {
    expect(payouts(settleCompetition([entry('a', 10)], 0))).toBe(0);
  });

  it('is deterministic regardless of input order', () => {
    const a = settleCompetition([entry('x', 5), entry('y', 5), entry('z', 9)], 500);
    const b = settleCompetition([entry('z', 9), entry('y', 5), entry('x', 5)], 500);
    expect(a).toEqual(b);
  });

  it('breaks value ties by a stable key rather than array order', () => {
    const results = settleCompetition([entry('b', 5), entry('a', 5)], 500);
    expect(results.map((r) => r.userId)).toEqual(['a', 'b']);
  });

  it('never awards a negative payout', () => {
    const results = settleCompetition(
      [entry('a', 1), entry('b', 1), entry('c', 1), entry('d', 1)], 3,
    );
    expect(results.every((r) => r.payout >= 0)).toBe(true);
    expect(payouts(results)).toBe(3);
  });
});
