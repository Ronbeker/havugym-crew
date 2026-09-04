/**
 * Weekly competition settlement.
 *
 * Settlement is the only place in the product where creatine is created from
 * nothing, so it has to be exactly right and exactly once. Three properties the
 * tests pin down:
 *
 *   1. DETERMINISTIC — same entries, same pot, same result, always.
 *   2. CONSERVATIVE  — payouts sum to exactly the pot, never a rounding cent more.
 *   3. IDEMPOTENT    — re-running cannot pay twice. Enforced not here but in the
 *                      database, by the unique index on creatine_ledger's ref.
 */

/** Prize split for the first three positions, before any tie adjustment. */
export const PODIUM_SHARES = [0.7, 0.2, 0.1] as const;

export interface CompetitionEntry {
  userId: string;
  /** The competition metric — total score, workout count or total volume. */
  value: number;
}

export interface CompetitionResult {
  userId: string;
  rank: number;
  value: number;
  payout: number;
}

/**
 * Standard competition ranking: two athletes tied for first are both rank 1 and
 * the next is rank 3. Ranks are assigned to everyone, including non-participants,
 * so the crew page can show a complete table.
 */
function assignRanks(entries: readonly CompetitionEntry[]): CompetitionResult[] {
  const sorted = [...entries].sort((a, b) =>
    b.value - a.value || a.userId.localeCompare(b.userId),
  );

  const out: CompetitionResult[] = [];
  let rank = 0;
  let previousValue: number | null = null;

  sorted.forEach((entry, index) => {
    if (previousValue === null || entry.value !== previousValue) rank = index + 1;
    previousValue = entry.value;
    out.push({ userId: entry.userId, rank, value: entry.value, payout: 0 });
  });

  return out;
}

/**
 * Distributes `total` across `weights` as whole numbers summing exactly to
 * `total`, using largest-remainder. Naive rounding would leak or invent creatine.
 */
function apportion(total: number, weights: readonly number[]): number[] {
  const weightSum = weights.reduce((a, b) => a + b, 0);
  if (weightSum <= 0) return weights.map(() => 0);

  const exact = weights.map((w) => (w / weightSum) * total);
  const floors = exact.map(Math.floor);
  let remaining = total - floors.reduce((a, b) => a + b, 0);

  const order = exact
    .map((value, index) => ({ index, remainder: value - Math.floor(value) }))
    .sort((a, b) => b.remainder - a.remainder || a.index - b.index);

  const result = [...floors];
  for (const { index } of order) {
    if (remaining <= 0) break;
    result[index] += 1;
    remaining -= 1;
  }
  return result;
}

export function settleCompetition(
  entries: readonly CompetitionEntry[],
  potCreatine: number,
): CompetitionResult[] {
  const ranked = assignRanks(entries);

  // Someone who did not train did not compete. Ranking them is fine; paying
  // them is not.
  const eligible = ranked.filter((r) => r.value > 0);
  if (eligible.length === 0 || potCreatine <= 0) return ranked;

  // Group tied athletes: a tie spanning positions 1-2 pools those two shares and
  // splits them evenly, rather than the alphabetically-luckier one taking 0.7.
  const groups = new Map<number, CompetitionResult[]>();
  for (const result of eligible) {
    const group = groups.get(result.rank) ?? [];
    group.push(result);
    groups.set(result.rank, group);
  }

  const groupWeights: { members: CompetitionResult[]; weight: number }[] = [];
  for (const [rank, members] of [...groups.entries()].sort((a, b) => a[0] - b[0])) {
    // Positions this group occupies: rank, rank+1, … rank+members.length-1.
    let weight = 0;
    for (let position = rank; position < rank + members.length; position++) {
      weight += PODIUM_SHARES[position - 1] ?? 0;
    }
    if (weight > 0) groupWeights.push({ members, weight });
  }

  if (groupWeights.length === 0) return ranked;

  // With fewer than three participants the unclaimed share is redistributed, so
  // the crew always pays out the whole pot it committed.
  const perGroup = apportion(potCreatine, groupWeights.map((g) => g.weight));

  groupWeights.forEach((group, index) => {
    const shares = apportion(perGroup[index], group.members.map(() => 1));
    group.members.forEach((member, i) => {
      member.payout = shares[i];
    });
  });

  return ranked;
}
