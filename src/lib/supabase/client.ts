'use client';

import { createBrowserClient } from '@supabase/ssr';
import type { Database } from '@/lib/database.types';

/**
 * Browser client. Carries only the publishable key, which grants no authority of
 * its own — every request it makes is still filtered by Row Level Security.
 *
 * Used for auth state changes and realtime. All data mutations go through Server
 * Actions instead, so validation and business rules cannot be skipped by calling
 * the API directly from a console.
 */
export function createSupabaseBrowserClient() {
  return createBrowserClient<Database>(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
  );
}
