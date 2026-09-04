import { createClient, type SupabaseClient } from '@supabase/supabase-js';
import { readFileSync } from 'node:fs';
import type { Database } from '@/lib/database.types';

/**
 * Helpers for tests that run against the REAL Supabase project.
 *
 * These deliberately do not mock. The whole point is to assert that Postgres
 * refuses things — a mocked client would only prove that our mock refuses them.
 */
const env = Object.fromEntries(
  readFileSync(new URL('../../.env.local', import.meta.url), 'utf8')
    .split('\n')
    .filter((l) => l.trim() && !l.trim().startsWith('#') && l.includes('='))
    .map((l) => [l.slice(0, l.indexOf('=')).trim(), l.slice(l.indexOf('=') + 1).trim()]),
);

export const SUPABASE_URL = env.NEXT_PUBLIC_SUPABASE_URL;
export const ANON_KEY = env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
export const SERVICE_KEY = env.SUPABASE_SERVICE_ROLE_KEY;

/** Every account these tests create uses this domain, so cleanup can find them. */
export const TEST_DOMAIN = '@havugym-itest.com';
export const TEST_PASSWORD = 'IntegrationTest2026!';

export const admin = (): SupabaseClient<Database> =>
  createClient<Database>(SUPABASE_URL, SERVICE_KEY, { auth: { persistSession: false } });

export const anon = (): SupabaseClient<Database> =>
  createClient<Database>(SUPABASE_URL, ANON_KEY, { auth: { persistSession: false } });

export interface TestUser {
  id: string;
  email: string;
  name: string;
  client: SupabaseClient<Database>;
}

/** A signed-in client whose requests carry a real user JWT, so RLS applies. */
export async function createTestUser(name: string): Promise<TestUser> {
  const email = `${name.toLowerCase()}-${Date.now()}-${Math.random().toString(36).slice(2, 8)}${TEST_DOMAIN}`;

  const { data, error } = await admin().auth.admin.createUser({
    email,
    password: TEST_PASSWORD,
    email_confirm: true,
    user_metadata: { display_name: name },
  });
  if (error) throw new Error(`createTestUser(${name}): ${error.message}`);

  const client = createClient<Database>(SUPABASE_URL, ANON_KEY, {
    auth: { persistSession: false, autoRefreshToken: false },
  });
  const { error: signInError } = await client.auth.signInWithPassword({
    email,
    password: TEST_PASSWORD,
  });
  if (signInError) throw new Error(`signIn(${name}): ${signInError.message}`);

  return { id: data.user.id, email, name, client };
}

/** Deletes every account this suite created. Cascades clear their data. */
export async function cleanupTestUsers() {
  const a = admin();
  const { data } = await a.auth.admin.listUsers({ perPage: 500 });
  const targets = (data?.users ?? []).filter((u) => u.email?.endsWith(TEST_DOMAIN));
  for (const user of targets) await a.auth.admin.deleteUser(user.id);
  return targets.length;
}

/** Creates a crew owned by `user`, through the same RPC the app uses. */
export async function createCrew(user: TestUser, name: string): Promise<string> {
  const { data, error } = await user.client.rpc('create_havura', { p_name: name });
  if (error) throw new Error(`createCrew: ${error.message}`);
  return data as string;
}

export async function logWorkout(
  user: TestUser,
  havuraId: string,
  sets: { exercise_id: number; set_index: number; weight_kg: number; reps: number }[],
  overrides: { title?: string; durationMin?: number; performedAt?: string } = {},
): Promise<string> {
  const { data, error } = await user.client.rpc('log_workout', {
    p_havura_id: havuraId,
    p_performed_at: overrides.performedAt ?? new Date().toISOString(),
    p_title: overrides.title ?? 'Test session',
    p_notes: '',
    p_duration_min: overrides.durationMin ?? 60,
    p_sets: sets,
  });
  if (error) throw new Error(`logWorkout: ${error.message}`);
  return data as string;
}

export async function someExercises(count: number) {
  const { data } = await admin()
    .from('exercises')
    .select('id, name, equipment, muscle_primary')
    .order('id')
    .limit(count);
  return data ?? [];
}
