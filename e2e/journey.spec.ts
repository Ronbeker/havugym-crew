import { expect, test } from '@playwright/test';
import { signInAs, signUpThroughForm, unique } from './helpers';

/**
 * The critical path, end to end, against the deployed application.
 *
 * One long test rather than several short ones on purpose: the value is in
 * proving the WHOLE journey holds together — crew, session, score, feed, wallet.
 * Splitting it would re-run expensive setup per test and stop testing the seams,
 * which are what actually break.
 */
test('a member can sign up, start a crew, log a scored session, and see it in the feed', async ({ page }) => {
  // Signs up through the real form — the exact path a new user takes.
  await signUpThroughForm(page, 'Riley');

  // ---- onboarding -------------------------------------------------------
  await expect(page).toHaveURL(/\/onboarding/, { timeout: 30_000 });
  await expect(page.getByRole('heading', { name: /Welcome, Riley/ })).toBeVisible();

  const crewName = `E2E Crew ${unique()}`;
  await page.getByLabel('Crew name').fill(crewName);
  await page.getByRole('button', { name: 'Create crew' }).click();

  // ---- the crew page ----------------------------------------------------
  await expect(page).toHaveURL(/\/crew/, { timeout: 30_000 });
  await expect(page.getByRole('heading', { name: crewName })).toBeVisible();

  // A six-character invite code must be generated and shown.
  const code = (await page.getByText(/^[A-Z0-9]{6}$/).first().textContent())?.trim();
  expect(code).toMatch(/^[A-Z0-9]{6}$/);

  // Both weekly mechanics must exist for a brand-new crew, with no cron run.
  await expect(page.getByText("This week's challenge")).toBeVisible();
  await expect(page.getByText("This week's competition")).toBeVisible();

  // ---- logging a session ------------------------------------------------
  await page.goto('/log');
  await page.getByLabel('Session').fill('E2E push day');
  await page.getByLabel('Minutes').fill('50');

  await page.getByLabel('Add an exercise').fill('Barbell Bench Press');
  await page.getByRole('button', { name: /^Barbell Bench Press/ }).first().click();

  await page.getByLabel('Set 1 weight in kilograms').fill('80');
  await page.getByLabel('Set 1 repetitions').fill('8');

  // The projected score must appear BEFORE saving — that is the entire reason
  // the formula is mirrored in TypeScript.
  await expect(page.getByText('Projected score')).toBeVisible();

  await page.getByRole('button', { name: /Save session/ }).click();

  // ---- the saved session ------------------------------------------------
  await expect(page).toHaveURL(/\/workouts\//, { timeout: 30_000 });
  await expect(page.getByRole('heading', { name: 'E2E push day' })).toBeVisible();
  await expect(page.getByText('80 kg')).toBeVisible();

  // ---- it appears in the crew feed --------------------------------------
  await page.goto('/feed');
  await expect(page.getByText('E2E push day')).toBeVisible();

  // ---- the profile shows the untruncated name --------------------------
  await page.goto('/me');
  await expect(page.getByRole('heading', { name: 'Riley' })).toBeVisible();
  await expect(page.getByText('Welcome bonus')).toBeVisible();

  // ---- the wallet gates what can be bought ------------------------------
  await page.goto('/shop');
  // A new member has the 100 signup bonus, so the 150 title must be out of
  // reach and DISABLED, rather than failing at the database after a click.
  await expect(page.getByRole('button', { name: '150', exact: true })).toBeDisabled();
});

test('an empty session cannot be saved', async ({ page }) => {
  await signInAs(page, 'Jordan');
  await expect(page).toHaveURL(/\/onboarding/, { timeout: 30_000 });
  await page.getByLabel('Crew name').fill(`Empty Crew ${unique()}`);
  await page.getByRole('button', { name: 'Create crew' }).click();
  await expect(page).toHaveURL(/\/crew/, { timeout: 30_000 });

  await page.goto('/log');
  await page.getByLabel('Session').fill('Nothing at all');
  // With no sets there must be no save button to press in the first place.
  await expect(page.getByRole('button', { name: /Save session/ })).toHaveCount(0);
  await expect(page.getByText('Add an exercise and fill in at least one set.')).toBeVisible();
});

test('a wrong invite code is rejected with a clear message', async ({ page }) => {
  await signInAs(page, 'Casey');
  await expect(page).toHaveURL(/\/onboarding/, { timeout: 30_000 });

  await page.getByRole('button', { name: 'Join with a code' }).click();
  await page.getByLabel('Invite code').fill('ZZZZZZ');
  await page.getByRole('button', { name: 'Join crew' }).click();

  await expect(page.getByText(/does not match any crew/)).toBeVisible();
});

test('a signed-out visitor is sent to the login page', async ({ page }) => {
  await page.goto('/feed');
  await expect(page).toHaveURL(/\/login/);
});

test('the landing page is reachable without a session', async ({ page }) => {
  await page.goto('/');
  await expect(page.getByRole('heading', { name: /Training alone is optional/ })).toBeVisible();
});

test('the health endpoint reports a healthy deployment', async ({ request }) => {
  const response = await request.get('/api/health');
  expect(response.status()).toBe(200);

  const body = await response.json();
  expect(body.ok).toBe(true);
  expect(body.env.valid).toBe(true);
  expect(body.db.reachable).toBe(true);
  // The deployment must still be refusing anonymous reads.
  expect(body.rls.anonIsDenied).toBe(true);
});
