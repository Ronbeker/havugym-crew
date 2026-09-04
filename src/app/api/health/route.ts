import { NextResponse } from 'next/server';
import { inspectEnv } from '@/lib/env';
import { createAdminClient } from '@/lib/supabase/admin';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

/**
 * GET /api/health — deployment self-check.
 *
 * Answers three questions that "the variables appear in the dashboard" cannot:
 *
 *   1. Is the configuration actually valid, or just present?
 *   2. Can this function reach Postgres, and from which region?
 *   3. Is Row Level Security still switched on in production?
 *
 * The third is the interesting one. The check asserts that the ANON key is
 * *denied* — a 200 there would mean the catalogue had been left world-readable,
 * so this endpoint fails when security gets looser, which is the direction that
 * actually matters. It reports no secrets, only whether each name resolved.
 */
export async function GET() {
  const env = inspectEnv();

  const body: Record<string, unknown> = {
    ok: false,
    region: process.env.VERCEL_REGION ?? 'local',
    commit: process.env.VERCEL_GIT_COMMIT_SHA?.slice(0, 7) ?? 'local',
    env,
  };

  if (!env.valid) {
    return NextResponse.json(body, { status: 503 });
  }

  try {
    const admin = createAdminClient();
    const started = Date.now();

    const [exercises, shopItems] = await Promise.all([
      admin.from('exercises').select('*', { count: 'exact', head: true }),
      admin.from('shop_items').select('*', { count: 'exact', head: true }),
    ]);

    if (exercises.error) throw new Error(`exercises: ${exercises.error.message}`);
    if (shopItems.error) throw new Error(`shop_items: ${shopItems.error.message}`);

    // Deliberately a raw fetch rather than a Supabase client: we want the HTTP
    // status the anonymous role actually receives, not a wrapped error object.
    const anonProbe = await fetch(
      `${process.env.NEXT_PUBLIC_SUPABASE_URL}/rest/v1/exercises?select=id&limit=1`,
      {
        headers: {
          apikey: process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
          Authorization: `Bearer ${process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!}`,
        },
        cache: 'no-store',
      },
    );

    const rlsHoldsAnonOut = anonProbe.status === 401 || anonProbe.status === 403;

    body.db = {
      reachable: true,
      latencyMs: Date.now() - started,
      exercises: exercises.count,
      shopItems: shopItems.count,
    };
    body.rls = {
      anonReadStatus: anonProbe.status,
      anonIsDenied: rlsHoldsAnonOut,
    };
    body.ok = exercises.count === 660 && shopItems.count === 16 && rlsHoldsAnonOut;

    return NextResponse.json(body, { status: body.ok ? 200 : 503 });
  } catch (err) {
    body.db = { reachable: false, error: err instanceof Error ? err.message : String(err) };
    return NextResponse.json(body, { status: 503 });
  }
}
