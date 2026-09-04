import { createClient } from '@supabase/supabase-js';
import { serverEnv } from '@/lib/env';
import type { Database } from '@/lib/database.types';

/**
 * Service-role client. Bypasses Row Level Security entirely.
 *
 * Reserved for work that has no user session to act on behalf of — the Stripe
 * webhook, scheduled settlement, migrations verification. Anything acting for a
 * signed-in person must use the request-scoped client in ./server.ts instead, so
 * that RLS stays in force and a bug in our code cannot leak another crew's data.
 *
 * The guard below is not paranoia: importing this file into a Client Component
 * would ship the service-role key to the browser, which is the single worst
 * mistake available in this stack.
 */
export function createAdminClient() {
  if (typeof window !== 'undefined') {
    throw new Error('createAdminClient() was called in the browser — the service-role key must never leave the server.');
  }
  const env = serverEnv();
  return createClient<Database>(env.NEXT_PUBLIC_SUPABASE_URL, env.SUPABASE_SERVICE_ROLE_KEY, {
    auth: { persistSession: false, autoRefreshToken: false },
  });
}
