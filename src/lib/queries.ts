import { cookies } from 'next/headers';
import { createSupabaseServerClient } from '@/lib/supabase/server';
import type { Database } from '@/lib/database.types';

export type Profile = Database['public']['Tables']['profiles']['Row'];
export type FeedRow = Database['public']['Views']['workout_feed']['Row'];
export type WeeklyStat = Database['public']['Views']['weekly_user_stats']['Row'];
export type Exercise = Database['public']['Tables']['exercises']['Row'];
export type ShopItem = Database['public']['Tables']['shop_items']['Row'];
export type LedgerRow = Database['public']['Tables']['creatine_ledger']['Row'];

/** Which crew the UI is currently showing, for members of more than one. */
export const ACTIVE_HAVURA_COOKIE = 'active_havura';

export interface HavuraMembership {
  id: string;
  name: string;
  inviteCode: string;
  role: Database['public']['Enums']['havura_role'];
  joinedAt: string;
}

export async function getProfile(): Promise<Profile | null> {
  const supabase = await createSupabaseServerClient();
  const { data: auth } = await supabase.auth.getUser();
  if (!auth.user) return null;

  const { data } = await supabase.from('profiles').select('*').eq('id', auth.user.id).single();
  return data ?? null;
}

/**
 * The crews this user belongs to. No user_id filter is needed or wanted — the
 * RLS policy on havura_members already restricts the rows to crews the caller
 * is in, so adding a filter here would duplicate a rule that lives in one place.
 */
export async function getMyHavuras(): Promise<HavuraMembership[]> {
  const supabase = await createSupabaseServerClient();
  const { data: auth } = await supabase.auth.getUser();
  if (!auth.user) return [];

  const { data } = await supabase
    .from('havura_members')
    .select('role, joined_at, havuras(id, name, invite_code)')
    .eq('user_id', auth.user.id)
    .order('joined_at', { ascending: true });

  return (data ?? [])
    .filter((row) => row.havuras)
    .map((row) => ({
      id: row.havuras!.id,
      name: row.havuras!.name,
      inviteCode: row.havuras!.invite_code,
      role: row.role,
      joinedAt: row.joined_at,
    }));
}

/**
 * Resolves the active crew from a cookie, falling back to the first joined.
 *
 * The cookie is a hint, never an authority: its value is checked against actual
 * membership before use, so editing it in devtools selects nothing you were not
 * already in.
 */
export async function getActiveHavura(): Promise<HavuraMembership | null> {
  const memberships = await getMyHavuras();
  if (memberships.length === 0) return null;

  const preferred = (await cookies()).get(ACTIVE_HAVURA_COOKIE)?.value;
  return memberships.find((m) => m.id === preferred) ?? memberships[0];
}

/**
 * Crew feed, newest first, KEYSET paginated.
 *
 * Deliberately not `.range(offset, offset+n)`: OFFSET makes Postgres walk and
 * discard every skipped row, so page 50 costs fifty pages of work. Seeking on
 * performed_at uses the (havura_id, performed_at desc) index directly, and costs
 * the same on page 50 as on page 1.
 */
export async function getCrewFeed(
  havuraId: string,
  options: { limit?: number; before?: string } = {},
): Promise<{ rows: FeedRow[]; nextCursor: string | null }> {
  const limit = Math.min(options.limit ?? 20, 50);
  const supabase = await createSupabaseServerClient();

  let query = supabase
    .from('workout_feed')
    .select('*')
    .eq('havura_id', havuraId)
    .order('performed_at', { ascending: false })
    .limit(limit + 1);

  if (options.before) query = query.lt('performed_at', options.before);

  const { data } = await query;
  const rows = data ?? [];
  const hasMore = rows.length > limit;
  const page = hasMore ? rows.slice(0, limit) : rows;

  return {
    rows: page,
    nextCursor: hasMore ? (page[page.length - 1]?.performed_at ?? null) : null,
  };
}

export async function getWorkoutDetail(workoutId: string) {
  const supabase = await createSupabaseServerClient();

  const [{ data: workout }, { data: sets }] = await Promise.all([
    supabase.from('workout_feed').select('*').eq('id', workoutId).maybeSingle(),
    supabase
      .from('workout_sets')
      .select('set_index, weight_kg, reps, rpe, exercises(id, name, muscle_primary, equipment)')
      .eq('workout_id', workoutId)
      .order('set_index', { ascending: true }),
  ]);

  if (!workout) return null;
  return { workout, sets: sets ?? [] };
}

/** Exercise search for the logger's picker. Server-side so we never ship 660 rows. */
export async function searchExercises(term: string, limit = 25): Promise<Exercise[]> {
  const supabase = await createSupabaseServerClient();
  const cleaned = term.trim();

  let query = supabase.from('exercises').select('*').order('name').limit(limit);
  if (cleaned.length > 0) query = query.ilike('name', `%${cleaned}%`);

  const { data } = await query;
  return data ?? [];
}

/** The athlete's most recent previous sessions, for the scoring baseline. */
export async function getScoringBaseline(userId: string, limit = 8) {
  const supabase = await createSupabaseServerClient();
  const { data } = await supabase
    .from('workout_feed')
    .select('volume, duration_min')
    .eq('user_id', userId)
    .order('performed_at', { ascending: false })
    .limit(limit);

  return (data ?? []).map((row) => ({
    volume: Number(row.volume ?? 0),
    durationMin: row.duration_min ?? 1,
  }));
}

export async function getWeeklyStats(havuraId: string, weekStart: string): Promise<WeeklyStat[]> {
  const supabase = await createSupabaseServerClient();
  const { data } = await supabase
    .from('weekly_user_stats')
    .select('*')
    .eq('havura_id', havuraId)
    .eq('week_start', weekStart);
  return data ?? [];
}

export async function getCrewRoster(havuraId: string) {
  const supabase = await createSupabaseServerClient();
  const { data } = await supabase
    .from('havura_members')
    .select('user_id, role, joined_at, profiles(display_name, avatar_url)')
    .eq('havura_id', havuraId)
    .order('joined_at', { ascending: true });
  return data ?? [];
}

export async function getWallet(limit = 15) {
  const supabase = await createSupabaseServerClient();
  const [{ data: profile }, { data: ledger }] = await Promise.all([
    supabase.from('profiles').select('creatine_balance').single(),
    supabase
      .from('creatine_ledger')
      .select('*')
      .order('created_at', { ascending: false })
      .limit(limit),
  ]);

  return {
    balance: profile?.creatine_balance ?? 0,
    ledger: (ledger ?? []) as LedgerRow[],
  };
}

export async function getShopState() {
  const supabase = await createSupabaseServerClient();
  const [{ data: items }, { data: owned }] = await Promise.all([
    supabase.from('shop_items').select('*').eq('active', true).order('price_creatine'),
    supabase.from('inventory').select('item_id, equipped'),
  ]);

  const ownedMap = new Map((owned ?? []).map((row) => [row.item_id, row.equipped]));
  return {
    items: (items ?? []) as ShopItem[],
    owned: ownedMap,
  };
}

/** Days since each primary muscle was last trained — input to the recommendation. */
export async function getMuscleTouches(userId: string, sinceDays = 28) {
  const supabase = await createSupabaseServerClient();
  const since = new Date(Date.now() - sinceDays * 86_400_000).toISOString();

  const { data } = await supabase
    .from('workout_feed')
    .select('performed_at, muscles')
    .eq('user_id', userId)
    .gte('performed_at', since)
    .order('performed_at', { ascending: false });

  const lastSeen = new Map<string, string>();
  for (const row of data ?? []) {
    for (const muscle of row.muscles ?? []) {
      if (!lastSeen.has(muscle)) lastSeen.set(muscle, row.performed_at!);
    }
  }

  return [...lastSeen.entries()].map(([muscle, at]) => ({
    muscle,
    daysAgo: Math.floor((Date.now() - new Date(at).getTime()) / 86_400_000),
  }));
}
