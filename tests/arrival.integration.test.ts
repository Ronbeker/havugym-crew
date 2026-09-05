import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import {
  admin, anon, cleanupTestUsers, createCrew, createTestUser, logWorkout, someExercises,
  type TestUser,
} from './helpers/db';

/**
 * Arrivals against the real database.
 *
 * Two properties that only the database can enforce, and one that only it can
 * time: crew isolation, one open arrival per member, and expiry decided by the
 * database clock rather than by whichever server rendered the page.
 */
describe('arrivals', () => {
  let alice: TestUser;
  let mallory: TestUser;
  let aliceCrew: string;
  let exercises: Awaited<ReturnType<typeof someExercises>>;

  beforeAll(async () => {
    await cleanupTestUsers();
    exercises = await someExercises(2);
    alice = await createTestUser('Ava');
    mallory = await createTestUser('Mal');
    aliceCrew = await createCrew(alice, 'Arrival Crew');
  }, 60_000);

  afterAll(async () => {
    await cleanupTestUsers();
  });

  it('announces an arrival and shows it as active', async () => {
    const { error } = await alice.client.rpc('announce_arrival', {
      p_havura_id: aliceCrew, p_status: 'training', p_note: 'leg day, who is in',
    });
    expect(error).toBeNull();

    const { data } = await alice.client
      .from('active_arrivals').select('*').eq('havura_id', aliceCrew);
    expect(data).toHaveLength(1);
    expect(data![0].status).toBe('training');
    expect(data![0].note).toBe('leg day, who is in');
  });

  it('keeps only ONE open arrival per member per crew', async () => {
    // Announcing again is how a member escalates on_the_way -> training. It must
    // replace, not collide with the partial unique index.
    await alice.client.rpc('announce_arrival', { p_havura_id: aliceCrew, p_status: 'on_the_way' });
    await alice.client.rpc('announce_arrival', { p_havura_id: aliceCrew, p_status: 'training' });

    const { count } = await admin()
      .from('arrivals')
      .select('*', { count: 'exact', head: true })
      .eq('user_id', alice.id)
      .is('closed_at', null);
    expect(count).toBe(1);
  });

  it('chooses the window on the SERVER, from the status', async () => {
    await alice.client.rpc('announce_arrival', { p_havura_id: aliceCrew, p_status: 'on_the_way' });
    const onTheWay = await admin().from('arrivals')
      .select('announced_at, expires_at').eq('user_id', alice.id).is('closed_at', null).single();
    const shortWindow =
      (new Date(onTheWay.data!.expires_at).getTime() - new Date(onTheWay.data!.announced_at).getTime()) / 60_000;

    await alice.client.rpc('announce_arrival', { p_havura_id: aliceCrew, p_status: 'training' });
    const training = await admin().from('arrivals')
      .select('announced_at, expires_at').eq('user_id', alice.id).is('closed_at', null).single();
    const longWindow =
      (new Date(training.data!.expires_at).getTime() - new Date(training.data!.announced_at).getTime()) / 60_000;

    expect(Math.round(shortWindow)).toBe(45);
    expect(Math.round(longWindow)).toBe(150);
    // A caller cannot ask to stay at the top of the crew's screen for a week.
    expect(longWindow).toBeLessThan(24 * 60);
  });

  it('hides an arrival once its window has passed, by the DATABASE clock', async () => {
    // Both timestamps have to move: the CHECK constraint arrivals_window_forward
    // refuses an expiry earlier than the announcement, which is exactly what it
    // is there for — an arrival cannot be born already stale.
    const { error: backdate } = await admin().from('arrivals')
      .update({
        announced_at: new Date(Date.now() - 3 * 3_600_000).toISOString(),
        expires_at: new Date(Date.now() - 3_600_000).toISOString(),
      })
      .eq('user_id', alice.id).is('closed_at', null);
    expect(backdate).toBeNull();

    const { data } = await alice.client
      .from('active_arrivals').select('id').eq('havura_id', aliceCrew);
    expect(data ?? []).toHaveLength(0);
  });

  it('refuses an arrival that expires before it was announced', async () => {
    await alice.client.rpc('announce_arrival', { p_havura_id: aliceCrew, p_status: 'training' });
    const { error } = await admin().from('arrivals')
      .update({ expires_at: new Date(Date.now() - 10 * 60_000).toISOString() })
      .eq('user_id', alice.id).is('closed_at', null);
    expect(error).not.toBeNull();
    expect(error!.message).toContain('arrivals_window_forward');
  });

  it('is invisible to someone outside the crew', async () => {
    await alice.client.rpc('announce_arrival', { p_havura_id: aliceCrew, p_status: 'training' });

    const { data } = await mallory.client
      .from('active_arrivals').select('id').eq('havura_id', aliceCrew);
    expect(data ?? []).toHaveLength(0);
  });

  it('is invisible to an anonymous caller', async () => {
    const { error } = await anon().from('active_arrivals').select('id').limit(1);
    expect(error).not.toBeNull();
  });

  it('cannot be announced into a crew you are not in', async () => {
    const { error } = await mallory.client.rpc('announce_arrival', {
      p_havura_id: aliceCrew, p_status: 'training',
    });
    expect(error?.message).toContain('NOT_A_MEMBER');
  });

  it('closes when the member logs the session it led to, and links the two', async () => {
    await alice.client.rpc('announce_arrival', { p_havura_id: aliceCrew, p_status: 'training' });

    const workoutId = await logWorkout(alice, aliceCrew, [
      { exercise_id: exercises[0].id, set_index: 1, weight_kg: 60, reps: 8 },
    ]);

    const { data: open } = await alice.client
      .from('active_arrivals').select('id').eq('havura_id', aliceCrew);
    expect(open ?? []).toHaveLength(0);

    const { data: linked } = await admin()
      .from('arrivals').select('workout_id, closed_at')
      .eq('user_id', alice.id).eq('workout_id', workoutId).single();
    expect(linked!.workout_id).toBe(workoutId);
    expect(linked!.closed_at).not.toBeNull();
  });

  it('can be closed by the member without logging anything', async () => {
    await alice.client.rpc('announce_arrival', { p_havura_id: aliceCrew, p_status: 'on_the_way' });
    const { error } = await alice.client.rpc('close_arrival', { p_havura_id: aliceCrew });
    expect(error).toBeNull();

    const { data } = await alice.client
      .from('active_arrivals').select('id').eq('havura_id', aliceCrew);
    expect(data ?? []).toHaveLength(0);
  });

  it('cannot be closed on somebody else\'s behalf', async () => {
    await alice.client.rpc('announce_arrival', { p_havura_id: aliceCrew, p_status: 'training' });

    // close_arrival derives the user from auth.uid(), so Mallory closing "the
    // crew's" arrivals closes nothing — she has none.
    await mallory.client.rpc('close_arrival', { p_havura_id: aliceCrew });

    const { count } = await admin()
      .from('arrivals').select('*', { count: 'exact', head: true })
      .eq('user_id', alice.id).is('closed_at', null);
    expect(count).toBe(1);
  });
});
