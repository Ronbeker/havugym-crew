import { createClient } from '@supabase/supabase-js';
import { readFileSync } from 'node:fs';

// Playwright loads specs as CommonJS, where import.meta does not exist; the
// runner always starts at the project root, so cwd is the reliable anchor.
import type { Page } from '@playwright/test';

export const PASSWORD = 'E2ePassword2026!';
export const E2E_DOMAIN = '@havugym-e2e.com';

const env = Object.fromEntries(
  readFileSync(`${process.cwd()}/.env.local`, 'utf8')
    .split('\n')
    .filter((l) => l.trim() && !l.trim().startsWith('#') && l.includes('='))
    .map((l) => [l.slice(0, l.indexOf('=')).trim(), l.slice(l.indexOf('=') + 1).trim()]),
);

const admin = () =>
  createClient(env.NEXT_PUBLIC_SUPABASE_URL, env.SUPABASE_SERVICE_ROLE_KEY, {
    auth: { persistSession: false },
  });

export const unique = () => `${Date.now()}-${Math.random().toString(36).slice(2, 7)}`;

/**
 * Creates a confirmed account, then signs in THROUGH THE UI.
 *
 * The account is provisioned with the admin API rather than the signup form for
 * a specific reason: this project has email confirmation enabled, and Supabase's
 * built-in mailer allows two messages an hour. Driving the signup form would
 * make the entire suite depend on an inbox and a rate limit — flaky by design,
 * and slower every run.
 *
 * The signup form itself is still covered: by the schema unit tests, and by the
 * spec below that asserts it correctly asks the user to confirm their email.
 * Everything after authentication is exercised through the real interface.
 */
export async function signInAs(page: Page, name: string) {
  const email = `${name.toLowerCase()}-${unique()}${E2E_DOMAIN}`;

  const { error } = await admin().auth.admin.createUser({
    email,
    password: PASSWORD,
    email_confirm: true,
    user_metadata: { display_name: name },
  });
  if (error) throw new Error(`could not provision ${email}: ${error.message}`);

  await page.goto('/login');
  await page.getByLabel('Email').fill(email);
  await page.getByLabel('Password').fill(PASSWORD);
  await page.getByRole('button', { name: 'Sign in' }).last().click();

  return email;
}
