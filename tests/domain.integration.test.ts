import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import {
  admin, cleanupTestUsers, createCrew, createTestUser, logWorkout, someExercises,
  type TestUser,
} from './helpers/db';
import { scoreWorkout, type PriorWorkout, type ScoredSet } from '@/lib/domain/scoring';

/**
 * The two properties that cannot be tested without a real database.
 */
describe('database-backed domain guarantees', () => {
  let athlete: TestUser;
  let crew: string;
  let exercises: Awaited<ReturnType<typeof someExercises>>;

  beforeAll(async () => {
    await cleanupTestUsers();
    athlete = await createTestUser('Parity');
    crew = await createCrew(athlete, 'Parity Crew');

    // A bodyweight movement is included on purpose: the 30kg proxy is the part
    // most likely to drift between the two implementations.
    const { data } = await admin()
      .from('exercises')
      .select('id, name, equipment, muscle_primary')
      .in('equipment', ['barbell', 'bodyweight'])
      .order('id')
      .limit(40);
    exercises = (data ?? []).filter((e, i, all) =>
      all.findIndex((x) => x.equipment === e.equipment) === i || i < 6);
  }, 60_000);

  afterAll(async () => {
    await cleanupTestUsers();
  });

  /**
   * SQL ↔ TypeScript parity.
   *
   * compute_workout_score() is authoritative; scoreWorkout() draws the preview.
   * If they disagree, the number a member watches while entering a session is
   * not the number they are given for it. This test is the only thing stopping
   * the two drifting, because nothing else forces an edit to one into the other.
   */
  describe('scoring parity between plpgsql and TypeScript', () => {
    const cases = [
      { label: 'a single barbell set', sets: [{ w: 80, r: 8 }], duration: 45 },
      { label: 'a normal session', sets: [{ w: 100, r: 5 }, { w: 90, r: 8 }, { w: 80, r: 10 }], duration: 60 },
      { label: 'a very long session', sets: [{ w: 60, r: 12 }, { w: 60, r: 12 }], duration: 180 },
      { label: 'a very short session', sets: [{ w: 140, r: 3 }], duration: 5 },
      { label: 'a zero-load set', sets: [{ w: 0, r: 15 }], duration: 30 },
      { label: 'high reps', sets: [{ w: 20, r: 100 }], duration: 40 },
      { label: 'heavy singles', sets: [{ w: 200, r: 1 }, { w: 210, r: 1 }], duration: 50 },
    ];

    it.each(cases)('agrees on $label', async ({ sets, duration }) => {
      const exercise = exercises[0];

      // Build the same baseline the SQL will see: this athlete's prior sessions.
      const { data: priorRows } = await admin()
        .from('workout_feed')
        .select('volume, duration_min')
        .eq('user_id', athlete.id)
        .order('performed_at', { ascending: false })
        .limit(8);

      const priors: PriorWorkout[] = (priorRows ?? []).map((r) => ({
        volume: Number(r.volume ?? 0),
        durationMin: r.duration_min ?? 1,
      }));

      const workoutId = await logWorkout(
        athlete,
        crew,
        sets.map((s, i) => ({
          exercise_id: exercise.id, set_index: i + 1, weight_kg: s.w, reps: s.r,
        })),
        { durationMin: duration },
      );

      const { data: stored } = await admin()
        .from('workouts').select('score').eq('id', workoutId).single();

      const scoredSets: ScoredSet[] = sets.map((s) => ({
        reps: s.r,
        weightKg: s.w,
        equipment: exercise.equipment,
        musclePrimary: exercise.muscle_primary,
      }));

      const expected = scoreWorkout({ sets: scoredSets, durationMin: duration, priors });

      // Postgres numeric is exact; JavaScript is float64. A cent of tolerance is
      // honest about that rather than pretending the two are bit-identical.
      expect(Math.abs(Number(stored!.score) - expected.score)).toBeLessThanOrEqual(0.01);
    });
  });

  /**
   * The ledger invariant. Everything about the currency rests on this.
   */
  describe('creatine ledger', () => {
    it('credits once when the same reference is applied twice', async () => {
      const before = await admin()
        .from('profiles').select('creatine_balance').eq('id', athlete.id).single();

      const ref = `idempotency-${Date.now()}`;
      for (let attempt = 0; attempt < 3; attempt++) {
        await admin().rpc('apply_creatine', {
          p_user_id: athlete.id, p_delta: 500, p_reason: 'admin_adjust',
          p_ref_type: 'test', p_ref_id: ref,
        });
      }

      const after = await admin()
        .from('profiles').select('creatine_balance').eq('id', athlete.id).single();

      expect(after.data!.creatine_balance).toBe(before.data!.creatine_balance + 500);
    });

    it('refuses to let a balance go negative', async () => {
      const { data: balance } = await admin()
        .from('profiles').select('creatine_balance').eq('id', athlete.id).single();

      const { error } = await admin().rpc('apply_creatine', {
        p_user_id: athlete.id,
        p_delta: -(balance!.creatine_balance + 1),
        p_reason: 'admin_adjust',
        p_ref_type: 'test',
        p_ref_id: `overdraft-${Date.now()}`,
      });

      expect(error?.message).toContain('INSUFFICIENT_CREATINE');
    });

    it('keeps the cached balance equal to the sum of the ledger', async () => {
      const [{ data: profile }, { data: ledger }] = await Promise.all([
        admin().from('profiles').select('creatine_balance').eq('id', athlete.id).single(),
        admin().from('creatine_ledger').select('delta').eq('user_id', athlete.id),
      ]);

      const sum = (ledger ?? []).reduce((total, row) => total + row.delta, 0);
      expect(profile!.creatine_balance).toBe(sum);
    });

    it('records a running balance on every row that matches the replayed sum', async () => {
      const { data: ledger } = await admin()
        .from('creatine_ledger')
        .select('delta, balance_after, created_at')
        .eq('user_id', athlete.id)
        .order('created_at', { ascending: true });

      let running = 0;
      for (const row of ledger ?? []) {
        running += row.delta;
        expect(row.balance_after).toBe(running);
      }
    });
  });

  describe('shop purchases', () => {
    it('cannot buy an item twice', async () => {
      const { data: item } = await admin()
        .from('shop_items').select('id, price_creatine').eq('slug', 'title_rookie').single();

      await admin().rpc('apply_creatine', {
        p_user_id: athlete.id, p_delta: item!.price_creatine * 2, p_reason: 'admin_adjust',
        p_ref_type: 'test', p_ref_id: `topup-${Date.now()}`,
      });

      const first = await athlete.client.rpc('purchase_shop_item', { p_item_id: item!.id });
      expect(first.error).toBeNull();

      const second = await athlete.client.rpc('purchase_shop_item', { p_item_id: item!.id });
      expect(second.error?.message).toContain('ALREADY_OWNED');
    });

    it('refuses a purchase the wallet cannot cover, and grants nothing', async () => {
      const { data: item } = await admin()
        .from('shop_items').select('id').eq('slug', 'title_unbreakable').single();

      const { error } = await athlete.client.rpc('purchase_shop_item', { p_item_id: item!.id });
      expect(error).not.toBeNull();

      const { data: owned } = await admin()
        .from('inventory').select('item_id').eq('user_id', athlete.id).eq('item_id', item!.id);
      expect(owned ?? []).toHaveLength(0);
    });
  });
});
