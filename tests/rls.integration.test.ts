import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import {
  admin, anon, cleanupTestUsers, createCrew, createTestUser, logWorkout, someExercises,
  type TestUser,
} from './helpers/db';

/**
 * Row Level Security, asserted against the real database.
 *
 * This is the file that backs the security document. Every claim it makes about
 * isolation is a test here, and each test is written as an ATTACK: it tries the
 * thing that must not work, and passes only when the database refuses.
 */
describe('row level security', () => {
  let alice: TestUser;
  let mallory: TestUser;
  let aliceCrew: string;
  let malloryCrew: string;
  let aliceWorkout: string;
  let exercises: Awaited<ReturnType<typeof someExercises>>;

  beforeAll(async () => {
    await cleanupTestUsers();
    exercises = await someExercises(3);

    alice = await createTestUser('Alice');
    mallory = await createTestUser('Mallory');

    aliceCrew = await createCrew(alice, 'Alice Crew');
    malloryCrew = await createCrew(mallory, 'Mallory Crew');

    aliceWorkout = await logWorkout(alice, aliceCrew, [
      { exercise_id: exercises[0].id, set_index: 1, weight_kg: 80, reps: 8 },
      { exercise_id: exercises[1].id, set_index: 1, weight_kg: 60, reps: 10 },
    ]);
  }, 60_000);

  afterAll(async () => {
    await cleanupTestUsers();
  });

  describe('anonymous callers', () => {
    it('cannot read the exercise catalogue', async () => {
      const { data, error } = await anon().from('exercises').select('id').limit(1);
      expect(error).not.toBeNull();
      expect(data).toBeNull();
    });

    it('cannot read any workout', async () => {
      const { data, error } = await anon().from('workouts').select('id').limit(1);
      expect(error).not.toBeNull();
      expect(data).toBeNull();
    });

    it('cannot read the feed view', async () => {
      const { error } = await anon().from('workout_feed').select('id').limit(1);
      expect(error).not.toBeNull();
    });

    it('cannot read the creatine ledger', async () => {
      const { error } = await anon().from('creatine_ledger').select('id').limit(1);
      expect(error).not.toBeNull();
    });
  });

  describe('cross-crew isolation', () => {
    it("Mallory cannot read Alice's workouts", async () => {
      const { data } = await mallory.client.from('workouts').select('id');
      expect(data ?? []).toHaveLength(0);
    });

    it("Mallory cannot read Alice's workout even knowing its id", async () => {
      const { data } = await mallory.client.from('workouts').select('id').eq('id', aliceWorkout);
      expect(data ?? []).toHaveLength(0);
    });

    it("Mallory cannot read Alice's sets through the child table", async () => {
      const { data } = await mallory.client
        .from('workout_sets').select('id').eq('workout_id', aliceWorkout);
      expect(data ?? []).toHaveLength(0);
    });

    it("Mallory cannot read Alice's crew", async () => {
      const { data } = await mallory.client.from('havuras').select('id').eq('id', aliceCrew);
      expect(data ?? []).toHaveLength(0);
    });

    it("Mallory cannot enumerate Alice's crew by invite code", async () => {
      // No SELECT path exists on invite_code at all — joining goes through the
      // join_havura RPC, so a guessed code cannot be confirmed by querying.
      const { data } = await mallory.client.from('havuras').select('id').limit(100);
      expect((data ?? []).map((r) => r.id)).not.toContain(aliceCrew);
    });

    it("Mallory cannot read Alice's profile without a shared crew", async () => {
      const { data } = await mallory.client
        .from('profiles').select('id').eq('id', alice.id);
      expect(data ?? []).toHaveLength(0);
    });

    it("Mallory cannot read Alice's ledger", async () => {
      const { data } = await mallory.client
        .from('creatine_ledger').select('id').eq('user_id', alice.id);
      expect(data ?? []).toHaveLength(0);
    });

    it('Alice can read her own workout', async () => {
      const { data } = await alice.client.from('workouts').select('id').eq('id', aliceWorkout);
      expect(data ?? []).toHaveLength(1);
    });

    it('Mallory cannot log a workout into a crew she is not in', async () => {
      const { error } = await mallory.client.rpc('log_workout', {
        p_havura_id: aliceCrew,
        p_performed_at: new Date().toISOString(),
        p_title: 'Intrusion',
        p_notes: '',
        p_duration_min: 30,
        p_sets: [{ exercise_id: exercises[0].id, set_index: 1, weight_kg: 10, reps: 1 }],
      });
      expect(error?.message).toContain('NOT_A_MEMBER');
    });

    it("Mallory cannot delete Alice's workout", async () => {
      await mallory.client.from('workouts').delete().eq('id', aliceWorkout);
      const { count } = await admin()
        .from('workouts').select('*', { count: 'exact', head: true }).eq('id', aliceWorkout);
      expect(count).toBe(1);
    });
  });

  describe('privilege boundaries within a session', () => {
    it('a member cannot award themselves a score', async () => {
      const before = await admin()
        .from('workouts').select('score').eq('id', aliceWorkout).single();

      await alice.client.from('workouts').update({ score: 100 }).eq('id', aliceWorkout);

      const after = await admin()
        .from('workouts').select('score').eq('id', aliceWorkout).single();
      expect(after.data!.score).toBe(before.data!.score);
      expect(Number(after.data!.score)).not.toBe(100);
    });

    it('a member cannot mint their own creatine', async () => {
      const before = await admin()
        .from('profiles').select('creatine_balance').eq('id', alice.id).single();

      await alice.client.from('profiles').update({ creatine_balance: 999_999 }).eq('id', alice.id);

      const after = await admin()
        .from('profiles').select('creatine_balance').eq('id', alice.id).single();
      expect(after.data!.creatine_balance).toBe(before.data!.creatine_balance);
    });

    it('a member cannot call apply_creatine directly', async () => {
      const { error } = await alice.client.rpc('apply_creatine', {
        p_user_id: alice.id, p_delta: 100_000, p_reason: 'admin_adjust',
        p_ref_type: 'test', p_ref_id: 'test',
      });
      expect(error).not.toBeNull();
    });

    it('a member cannot insert a workout row directly, bypassing scoring', async () => {
      const { error } = await alice.client.from('workouts').insert({
        user_id: alice.id, havura_id: aliceCrew, performed_at: new Date().toISOString(),
        title: 'Direct insert', duration_min: 60, score: 100,
      });
      expect(error).not.toBeNull();
    });

    it('a member CAN correct the title of their own workout', async () => {
      const { error } = await alice.client
        .from('workouts').update({ title: 'Corrected title' }).eq('id', aliceWorkout);
      expect(error).toBeNull();

      const { data } = await admin()
        .from('workouts').select('title').eq('id', aliceWorkout).single();
      expect(data!.title).toBe('Corrected title');
    });
  });

  describe('joining a crew', () => {
    it('a wrong invite code is rejected without revealing whether it exists', async () => {
      const { error } = await mallory.client.rpc('join_havura', { p_code: 'ZZZZZZ' });
      expect(error?.message).toContain('INVALID_INVITE_CODE');
    });

    it('a correct code grants access, and only then', async () => {
      const { data: crew } = await admin()
        .from('havuras').select('invite_code').eq('id', aliceCrew).single();

      const before = await mallory.client.from('workouts').select('id').eq('id', aliceWorkout);
      expect(before.data ?? []).toHaveLength(0);

      const { error } = await mallory.client.rpc('join_havura', { p_code: crew!.invite_code });
      expect(error).toBeNull();

      const after = await mallory.client.from('workouts').select('id').eq('id', aliceWorkout);
      expect(after.data ?? []).toHaveLength(1);
    });

    it('joining twice is harmless', async () => {
      const { data: crew } = await admin()
        .from('havuras').select('invite_code').eq('id', malloryCrew).single();
      const first = await alice.client.rpc('join_havura', { p_code: crew!.invite_code });
      const second = await alice.client.rpc('join_havura', { p_code: crew!.invite_code });
      expect(first.error).toBeNull();
      expect(second.error).toBeNull();
    });
  });
});
