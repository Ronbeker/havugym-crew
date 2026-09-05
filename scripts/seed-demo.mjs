/**
 * scripts/seed-demo.mjs — a full-size demo crew.
 *
 * Ten members, six weeks of history, a second crew for the switcher, and three
 * situations deliberately constructed so the weekly mechanics are exercised
 * rather than merely present:
 *
 *   - one member who never trains, to prove non-participants are ranked but
 *     never paid;
 *   - two members given identical weekly totals, to force a TIE and prove the
 *     podium shares are pooled and split rather than won on a coin toss;
 *   - five completed weeks, so lazy settlement has real work to do.
 *
 * Deterministic: a seeded PRNG means the same command produces the same crew,
 * so a number quoted in a document stays true on the next run.
 *
 * Idempotent: demo accounts are deleted first, and the cascade clears their
 * workouts, ledger rows and memberships.
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

const PASSWORD = 'DemoCrew2026!';
const DOMAIN = '@havugym-demo.com';
const WEEKS = 6;

/** mulberry32 — small, seeded, and identical across runs. */
function rng(seed) {
  return function () {
    seed |= 0; seed = (seed + 0x6D2B79F5) | 0;
    let t = Math.imul(seed ^ (seed >>> 15), 1 | seed);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}
const rand = rng(20260906);
const between = (lo, hi) => Math.round(lo + rand() * (hi - lo));
const pick = (arr) => arr[Math.floor(rand() * arr.length)];

const MEMBERS = [
  { name: 'Dana',  sessionsPerWeek: 4, strength: 1.15, role: 'owner' },
  { name: 'Itay',  sessionsPerWeek: 4, strength: 1.05 },
  { name: 'Maya',  sessionsPerWeek: 3, strength: 0.95 },
  { name: 'Noam',  sessionsPerWeek: 3, strength: 1.00 },
  { name: 'Shira', sessionsPerWeek: 3, strength: 0.90 },
  { name: 'Omer',  sessionsPerWeek: 2, strength: 1.20 },
  { name: 'Tamar', sessionsPerWeek: 2, strength: 0.85 },
  { name: 'Yonatan', sessionsPerWeek: 2, strength: 1.10 },
  // The tie pair — identical volume every week, by construction.
  { name: 'Roni',  sessionsPerWeek: 3, strength: 1.00, twin: true },
  { name: 'Alon',  sessionsPerWeek: 3, strength: 1.00, twin: true },
  // The wobbler. Never trains. Must be ranked last and paid nothing.
  { name: 'Gil',   sessionsPerWeek: 0, strength: 1.00 },
];

const TEMPLATES = [
  { title: 'Push day',   muscles: ['chest', 'shoulders', 'triceps'], minutes: 62 },
  { title: 'Pull day',   muscles: ['back', 'biceps'],                minutes: 68 },
  { title: 'Leg day',    muscles: ['legs', 'glutes'],                minutes: 74 },
  { title: 'Upper body', muscles: ['chest', 'back', 'shoulders'],    minutes: 58 },
  { title: 'Full body',  muscles: ['legs', 'back', 'chest', 'core'], minutes: 70 },
  { title: 'Core + arms',muscles: ['core', 'biceps', 'triceps'],     minutes: 45 },
];

const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

async function listDemoUsers() {
  const { data } = await admin.auth.admin.listUsers({ perPage: 500 });
  return (data?.users ?? []).filter((u) => u.email?.endsWith(DOMAIN));
}

/**
 * Deleting an auth user cascades across every table that references it, and the
 * delete is not visible to the very next createUser call — re-creating the same
 * address immediately fails with "already registered". So we delete, then poll
 * until the addresses are actually free.
 */
async function wipe() {
  const targets = await listDemoUsers();
  for (const user of targets) await admin.auth.admin.deleteUser(user.id);

  for (let attempt = 0; attempt < 20; attempt++) {
    const remaining = await listDemoUsers();
    if (remaining.length === 0) break;
    await sleep(500);
    if (attempt === 19) throw new Error('demo accounts were not released after deletion');
  }

  // The crews SURVIVE their creator's deletion — created_by is ON DELETE SET
  // NULL by design (0009), because a crew is a shared object that outlives the
  // account that opened it. So the seed has to clear them explicitly.
  await admin.from('havuras').delete().in('invite_code', ['DEMO01', 'DEMO02']);

  return targets.length;
}

async function exercisesByMuscle() {
  const { data } = await admin
    .from('exercises')
    .select('id, name, muscle_primary, equipment')
    .order('id');

  const map = new Map();
  for (const row of data ?? []) {
    if (!map.has(row.muscle_primary)) map.set(row.muscle_primary, []);
    map.get(row.muscle_primary).push(row);
  }
  return map;
}

/** Sunday of the week `weeksAgo` back, at a plausible training hour. */
function sessionTime(weeksAgo, dayOffset) {
  const now = new Date();
  const sunday = new Date(now);
  sunday.setDate(now.getDate() - now.getDay() - weeksAgo * 7 + dayOffset);
  sunday.setHours(between(7, 20), between(0, 55), 0, 0);
  return sunday;
}

async function main() {
  const removed = await wipe();
  if (removed) console.log(`removed ${removed} existing demo account(s)`);

  const byMuscle = await exercisesByMuscle();

  const users = [];
  for (const member of MEMBERS) {
    const email = `${member.name.toLowerCase()}${DOMAIN}`;
    const { data, error } = await admin.auth.admin.createUser({
      email, password: PASSWORD, email_confirm: true,
      user_metadata: { display_name: member.name },
    });
    if (error) throw new Error(`${email}: ${error.message}`);
    users.push({ ...member, id: data.user.id, email });
  }
  console.log(`created ${users.length} members`);

  const { data: crew, error: crewError } = await admin
    .from('havuras')
    .insert({ name: 'Sunday Morning Club', invite_code: 'DEMO01', created_by: users[0].id })
    .select().single();
  if (crewError) throw new Error(crewError.message);

  await admin.from('havura_members').insert(
    users.map((u) => ({ havura_id: crew.id, user_id: u.id, role: u.role ?? 'member' })),
  );

  // A second crew, with two members overlapping, so the crew switcher has
  // something real to switch between.
  const { data: crew2 } = await admin
    .from('havuras')
    .insert({ name: 'Thursday Nights', invite_code: 'DEMO02', created_by: users[1].id })
    .select().single();
  await admin.from('havura_members').insert([
    { havura_id: crew2.id, user_id: users[1].id, role: 'owner' },
    { havura_id: crew2.id, user_id: users[2].id, role: 'member' },
  ]);
  console.log(`created crews: ${crew.invite_code}, ${crew2.invite_code}`);

  let logged = 0;

  for (let weeksAgo = WEEKS - 1; weeksAgo >= 0; weeksAgo--) {
    for (const user of users) {
      if (user.sessionsPerWeek === 0) continue;

      // Twins train identically, which is what produces the tie.
      const seedForUser = user.twin ? 999 : user.id.charCodeAt(0);
      const localRand = rng(seedForUser + weeksAgo * 31);

      for (let n = 0; n < user.sessionsPerWeek; n++) {
        const template = user.twin
          ? TEMPLATES[n % TEMPLATES.length]
          : pick(TEMPLATES);
        const performedAt = sessionTime(weeksAgo, user.twin ? n * 2 : between(0, 6));
        if (performedAt > new Date()) continue;   // no sessions in the future

        const { data: workout, error } = await admin.from('workouts').insert({
          user_id: user.id,
          havura_id: crew.id,
          performed_at: performedAt.toISOString(),
          title: template.title,
          duration_min: template.minutes + (user.twin ? 0 : between(-10, 10)),
          source: 'manual',
        }).select().single();
        if (error) throw new Error(error.message);

        const rows = [];
        for (const muscle of template.muscles) {
          const pool = byMuscle.get(muscle) ?? [];
          if (pool.length === 0) continue;
          const exercise = user.twin
            ? pool[n % pool.length]
            : pool[Math.floor(localRand() * pool.length)];

          const base = Math.round((user.twin ? 60 : between(35, 85)) * user.strength);
          const sets = user.twin ? 3 : between(3, 4);
          for (let setIndex = 1; setIndex <= sets; setIndex++) {
            rows.push({
              workout_id: workout.id,
              exercise_id: exercise.id,
              set_index: setIndex,
              weight_kg: exercise.equipment === 'bodyweight' ? 0 : base + setIndex * 2,
              reps: user.twin ? 8 : between(5, 12),
            });
          }
        }

        const seen = new Set();
        const unique = rows.filter((r) => {
          const key = `${r.exercise_id}:${r.set_index}`;
          if (seen.has(key)) return false;
          seen.add(key);
          return true;
        });
        if (unique.length === 0) continue;

        await admin.from('workout_sets').insert(unique);

        // The same function the application uses. The seed never invents a score.
        const { data: score } = await admin.rpc('compute_workout_score', {
          p_workout_id: workout.id,
        });
        await admin.from('workouts').update({ score }).eq('id', workout.id);
        logged++;
      }
    }
  }

  console.log(`logged ${logged} workouts across ${WEEKS} weeks`);
  console.log(`\nsign in with any of (password: ${PASSWORD}):`);
  for (const u of users) console.log(`  ${u.email}`);
  console.log(`\ninvite codes: ${crew.invite_code} (${crew.name}), ${crew2.invite_code} (${crew2.name})`);
}

main().catch((err) => { console.error(err.message); process.exit(1); });
