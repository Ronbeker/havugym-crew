import { defineConfig, devices } from '@playwright/test';

/**
 * End-to-end tests.
 *
 * baseURL defaults to the deployed application, so `npm run test:e2e` verifies
 * what users actually get rather than what happens to build locally. Point
 * E2E_BASE_URL at http://localhost:3000 to run the same specs against a dev server.
 *
 * The suite creates real accounts on a dedicated email domain and deletes them
 * in global teardown.
 */
export default defineConfig({
  testDir: './e2e',
  timeout: 90_000,
  expect: { timeout: 15_000 },
  fullyParallel: false,
  workers: 1,
  retries: process.env.CI ? 1 : 0,
  reporter: [['list']],
  globalTeardown: './e2e/teardown.ts',
  use: {
    baseURL: process.env.E2E_BASE_URL ?? 'https://havugym-crew.vercel.app',
    trace: 'retain-on-failure',
    screenshot: 'only-on-failure',
  },
  projects: [
    { name: 'chromium', use: { ...devices['Desktop Chrome'] } },
  ],
});
