/**
 * scripts/seed-demo.mjs — a demo crew with three weeks of history.
 *
 * Uses the service role, so it bypasses RLS and can create users with their
 * email already confirmed. Idempotent: re-running deletes the demo users first
 * (cascade clears their workouts, ledger and memberships) and rebuilds.
 *
 *   node scripts/seed-demo.mjs
 */
import { createClient } from '@supabase/supabase-js';
import { readFileSync } from 'node:fs';

const env = Object.fromEntries(
  readFileSync(new URL('../.env.local', import.meta.url), 'utf8')
    .split('\n')
    .filter((l) => l.trim() && !l.trim().startsWith('#') && l.includes('='))
    .map((l) => [l.slice(0, l.indexOf('=')).trim(), l.slice(l.indexOf('=') + 1).trim()]),
);

const admin = createClient(env.NEXT_PUBLIC_SUPABASE_URL, env.SUPABASE_SERVICE_ROLE_KEY, {
  auth: { persistSession: false },
});

export const DEMO_PASSWORD = 'DemoCrew2026!';
const MEMBERS = [
  { email: 'dana@havugym-demo.com', name: 'Dana' },
  { email: 'itay@havugym-demo.com', name: 'Itay' },
  { email: 'maya@havugym-demo.com', name: 'Maya' },
  { email: 'noam@havugym-demo.com', name: 'Noam' },
];

const SESSIONS = [
  { title: 'Push day',   slugs: ['barbell_bench_press', 'overhead_press', 'cable_tricep_pushdown'], minutes: 62 },
  { title: 'Pull day',   slugs: ['deadlift', 'pull_up', 'barbell_row'],                             minutes: 70 },
  { title: 'Leg day',    slugs: ['barbell_squat', 'romanian_deadlift', 'leg_press'],                minutes: 75 },
  { title: 'Upper body', slugs: ['incline_barbell_bench_press', 'lat_pulldown', 'dumbbell_curl'],   minutes: 55 },
];

const rand = (min, max) => Math.round(min + Math.random() * (max - min));

async function deleteDemoUsers() {
  const { data } = await admin.auth.admin.listUsers({ perPage: 200 });
  const targets = (data?.users ?? []).filter((u) => u.email?.endsWith('@havugym-demo.com'));
  for (const user of targets) await admin.auth.admin.deleteUser(user.id);
  return targets.length;
}

async function resolveExercises() {
  const slugs = [...new Set(SESSIONS.flatMap((s) => s.slugs))];
  const { data } = await admin.from('exercises').select('id, slug, name').in('slug', slugs);
  const bySlug = new Map((data ?? []).map((row) => [row.slug, row]));

  // Some slugs may not exist verbatim in the catalogue; fall back to any
  // exercise so the seed still produces a full-looking crew.
  const { data: fallback } = await admin.from('exercises').select('id, slug, name').limit(40);
  return { bySlug, fallback: fallback ?? [] };
}

async function main() {
  const removed = await deleteDemoUsers();
  if (removed) console.log(`removed ${removed} existing demo user(s)`);

  const users = [];
  for (const member of MEMBERS) {
    const { data, error } = await admin.auth.admin.createUser({
      email: member.email,
      password: DEMO_PASSWORD,
      email_confirm: true,
      user_metadata: { display_name: member.name },
    });
    if (error) throw new Error(`${member.email}: ${error.message}`);
    users.push({ ...member, id: data.user.id });
    console.log(`created ${member.name} <${member.email}>`);
  }

  const { data: havura, error: havuraError } = await admin
    .from('havuras')
    .insert({ name: 'Sunday Morning Club', invite_code: 'DEMO01', created_by: users[0].id })
    .select()
    .single();
  if (havuraError) throw new Error(havuraError.message);

  await admin.from('havura_members').insert(
    users.map((user, index) => ({
      havura_id: havura.id,
      user_id: user.id,
      role: index === 0 ? 'owner' : 'member',
    })),
  );
  console.log(`created crew "${havura.name}" (${havura.invite_code})`);

  const { bySlug, fallback } = await resolveExercises();
  let logged = 0;

  for (const user of users) {
    // Three weeks back to today, so there is settled history AND a live week.
    for (let daysAgo = 20; daysAgo >= 0; daysAgo -= rand(2, 3)) {
      const session = SESSIONS[rand(0, SESSIONS.length - 1)];
      const performedAt = new Date(Date.now() - daysAgo * 86_400_000);
      performedAt.setHours(rand(7, 20), rand(0, 59), 0, 0);

      const { data: workout, error } = await admin
        .from('workouts')
        .insert({
          user_id: user.id,
          havura_id: havura.id,
          performed_at: performedAt.toISOString(),
          title: session.title,
          duration_min: session.minutes + rand(-8, 8),
          source: 'manual',
        })
        .select()
        .single();
      if (error) throw new Error(error.message);

      const rows = [];
      for (const slug of session.slugs) {
        const exercise = bySlug.get(slug) ?? fallback[rand(0, fallback.length - 1)];
        if (!exercise) continue;
        const base = rand(30, 90);
        for (let setIndex = 1; setIndex <= rand(3, 4); setIndex++) {
          rows.push({
            workout_id: workout.id,
            exercise_id: exercise.id,
            set_index: setIndex,
            weight_kg: base + rand(0, 10),
            reps: rand(5, 12),
          });
        }
      }

      // Distinct exercises only — (workout_id, exercise_id, set_index) is unique.
      const seen = new Set();
      const unique = rows.filter((r) => {
        const key = `${r.exercise_id}:${r.set_index}`;
        if (seen.has(key)) return false;
        seen.add(key);
        return true;
      });

      await admin.from('workout_sets').insert(unique);

      // Same function the application uses — the seed never invents a score.
      const { data: score } = await admin.rpc('compute_workout_score', { p_workout_id: workout.id });
      await admin.from('workouts').update({ score }).eq('id', workout.id);
      logged++;
    }
  }

  console.log(`logged ${logged} workouts`);
  console.log('\nSign in with any of:');
  for (const user of users) console.log(`  ${user.email}   ${DEMO_PASSWORD}`);
  console.log(`\nInvite code: ${havura.invite_code}`);
}

main().catch((err) => {
  console.error(err.message);
  process.exit(1);
});
