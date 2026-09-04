import { z } from 'zod';

/**
 * Configuration is validated, not assumed.
 *
 * Every value is read through here so a missing or malformed variable produces
 * one clear error naming the variable, rather than a `undefined is not a
 * function` three layers into the Supabase client.
 *
 * Validation is deliberately lazy (a function, not a module-level parse). A
 * module-level parse would fail the *build* when a variable is absent, which
 * turns "the config is wrong" into "the deploy is broken" and hides which
 * variable was at fault. This way the app boots and can report the problem.
 *
 * NEXT_PUBLIC_ values are referenced by their literal names below because
 * Next.js inlines them at build time by textual match — reading them off a
 * spread copy of process.env silently yields undefined in a browser bundle.
 */
const serverSchema = z.object({
  NEXT_PUBLIC_SUPABASE_URL: z.string().url(),
  NEXT_PUBLIC_SUPABASE_ANON_KEY: z.string().min(20),
  SUPABASE_SERVICE_ROLE_KEY: z.string().min(20),
  NEXT_PUBLIC_SITE_URL: z.string().url(),
});

export type ServerEnv = z.infer<typeof serverSchema>;

function raw() {
  return {
    NEXT_PUBLIC_SUPABASE_URL: process.env.NEXT_PUBLIC_SUPABASE_URL,
    NEXT_PUBLIC_SUPABASE_ANON_KEY: process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY,
    SUPABASE_SERVICE_ROLE_KEY: process.env.SUPABASE_SERVICE_ROLE_KEY,
    NEXT_PUBLIC_SITE_URL: process.env.NEXT_PUBLIC_SITE_URL,
  };
}

/** Throws with the offending variable names. Use on the server only. */
export function serverEnv(): ServerEnv {
  const parsed = serverSchema.safeParse(raw());
  if (!parsed.success) {
    const bad = parsed.error.issues.map((i) => `${i.path.join('.')}: ${i.message}`).join('; ');
    throw new Error(`Invalid server environment — ${bad}`);
  }
  return parsed.data;
}

/** Non-throwing variant for the health endpoint: reports without exploding. */
export function inspectEnv() {
  const parsed = serverSchema.safeParse(raw());
  const present = Object.fromEntries(
    Object.entries(raw()).map(([k, v]) => [k, v ? 'set' : 'MISSING']),
  );
  return {
    valid: parsed.success,
    present,
    issues: parsed.success ? [] : parsed.error.issues.map((i) => `${i.path.join('.')}: ${i.message}`),
  };
}
