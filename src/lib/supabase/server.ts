import { createServerClient } from '@supabase/ssr';
import { cookies } from 'next/headers';
import { serverEnv } from '@/lib/env';
import type { Database } from '@/lib/database.types';

/**
 * Request-scoped Supabase client carrying the caller's session.
 *
 * This is the client almost everything should use. It sends the user's JWT, so
 * `auth.uid()` resolves inside every policy and the database itself decides what
 * the request may see. Our code never has to remember to filter by user — if we
 * forget a WHERE clause, RLS still returns nothing rather than everything.
 *
 * Contrast with createAdminClient(), which bypasses all of that.
 */
export async function createSupabaseServerClient() {
  const cookieStore = await cookies();
  const env = serverEnv();

  return createServerClient<Database>(
    env.NEXT_PUBLIC_SUPABASE_URL,
    env.NEXT_PUBLIC_SUPABASE_ANON_KEY,
    {
      cookies: {
        getAll: () => cookieStore.getAll(),
        setAll: (toSet) => {
          try {
            toSet.forEach(({ name, value, options }) => cookieStore.set(name, value, options));
          } catch {
            // Called from a Server Component, where cookies are read-only. The
            // middleware refreshes the session instead, so this is safe to drop.
          }
        },
      },
    },
  );
}

/** The signed-in user, or null. Never throws on an absent session. */
export async function getSessionUser() {
  const supabase = await createSupabaseServerClient();
  const { data, error } = await supabase.auth.getUser();
  if (error) return null;
  return data.user ?? null;
}
