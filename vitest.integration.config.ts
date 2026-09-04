import { defineConfig } from 'vitest/config';
import { fileURLToPath } from 'node:url';

/**
 * Integration tests run against the REAL Supabase project.
 *
 * They are a separate config because they are slow, require credentials, and
 * assert things a mock cannot: that the RLS policies actually deny, that the
 * SQL scoring function agrees with the TypeScript one, that the ledger really is
 * idempotent. Mocking those would only test our belief about Postgres.
 */
export default defineConfig({
  test: {
    environment: 'node',
    include: ['tests/**/*.integration.test.ts'],
    testTimeout: 45_000,
    hookTimeout: 60_000,
    fileParallelism: false,
  },
  resolve: {
    alias: { '@': fileURLToPath(new URL('./src', import.meta.url)) },
  },
});
