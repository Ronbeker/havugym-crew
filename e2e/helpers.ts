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
 * Signs up through the real form.
 *
 * Email confirmation is disabled on this project, so signUp returns a session
 * immediately and the journey continues straight into onboarding. This is the
 * path a real user takes, so it is the path the suite takes.
 */
export async function signUpThroughForm(page: Page, name: string) {
  const email = `${name.toLowerCase()}-${unique()}${E2E_DOMAIN}`;

  await page.goto('/login');
  await page.getByRole('button', { name: 'Create account' }).click();
  await page.getByLabel('Name').fill(name);
  await page.getByLabel('Email').fill(email);
  await page.getByLabel('Password').fill(PASSWORD);
  await page.getByRole('button', { name: 'Create account' }).last().click();

  return email;
}

/**
 * Provisions a confirmed account through the admin API, then signs in via the UI.
 *
 * Used where a test needs a second account and the signup path is not what is
 * under test — it is a couple of seconds faster and keeps the assertion focused.
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
