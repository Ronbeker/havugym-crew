import { createClient } from '@supabase/supabase-js';
import { readFileSync } from 'node:fs';

// Playwright loads specs as CommonJS, where import.meta does not exist; the
// runner always starts at the project root, so cwd is the reliable anchor.

/** Removes every account the E2E run created. */
export default async function globalTeardown() {
  const env = Object.fromEntries(
    readFileSync(`${process.cwd()}/.env.local`, 'utf8')
      .split('\n')
      .filter((l) => l.trim() && !l.trim().startsWith('#') && l.includes('='))
      .map((l) => [l.slice(0, l.indexOf('=')).trim(), l.slice(l.indexOf('=') + 1).trim()]),
  );

  const admin = createClient(env.NEXT_PUBLIC_SUPABASE_URL, env.SUPABASE_SERVICE_ROLE_KEY, {
    auth: { persistSession: false },
  });

  const { data } = await admin.auth.admin.listUsers({ perPage: 500 });
  const targets = (data?.users ?? []).filter((u) => u.email?.endsWith('@havugym-e2e.com'));
  for (const user of targets) await admin.auth.admin.deleteUser(user.id);
  if (targets.length) console.log(`\nteardown: removed ${targets.length} e2e account(s)`);
}
