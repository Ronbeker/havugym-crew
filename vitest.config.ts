import { defineConfig } from 'vitest/config';
import react from '@vitejs/plugin-react';
import { fileURLToPath } from 'node:url';

export default defineConfig({
  plugins: [react()],
  test: {
    environment: 'node',
    include: ['tests/**/*.test.ts', 'tests/**/*.test.tsx'],
    // Integration tests talk to the real database and are opt-in, so a plain
    // `npm test` stays fast, offline and deterministic.
    exclude: ['tests/**/*.integration.test.ts', 'node_modules/**'],
    globals: false,
  },
  resolve: {
    alias: { '@': fileURLToPath(new URL('./src', import.meta.url)) },
  },
});
