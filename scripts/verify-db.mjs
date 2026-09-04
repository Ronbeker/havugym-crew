/**
 * scripts/verify-db.mjs — post-migration smoke check.
 *
 * Asserts the shape of the deployed database rather than trusting that
 * `supabase db push` exiting zero meant it did the right thing. Run after every
 * migration push:  npm run db:verify
 */
import pg from 'pg';
import { readFileSync } from 'node:fs';

const env = Object.fromEntries(
  readFileSync(new URL('../.env.local', import.meta.url), 'utf8')
    .split('\n')
    .filter((l) => l.trim() && !l.trim().startsWith('#') && l.includes('='))
    .map((l) => [l.slice(0, l.indexOf('=')).trim(), l.slice(l.indexOf('=') + 1).trim()]),
);

if (!env.SUPABASE_DB_URL) throw new Error('SUPABASE_DB_URL missing from .env.local');

const client = new pg.Client({
  connectionString: env.SUPABASE_DB_URL,
  ssl: { rejectUnauthorized: false },
});
await client.connect();

const checks = [
  ['tables',            `select count(*)::int v from information_schema.tables where table_schema='public' and table_type='BASE TABLE'`, 14],
  ['enums',             `select count(*)::int v from pg_type where typtype='e' and typnamespace='public'::regnamespace`, 11],
  ['rls policies',      `select count(*)::int v from pg_policies where schemaname='public'`, 20],
  ['functions',         `select count(*)::int v from pg_proc p join pg_namespace n on n.oid=p.pronamespace where n.nspname='public'`, null],
  ['indexes',           `select count(*)::int v from pg_indexes where schemaname='public'`, null],
  ['exercises seeded',  `select count(*)::int v from public.exercises`, 660],
  ['shop items seeded', `select count(*)::int v from public.shop_items`, 16],
];

let failed = 0;
for (const [label, sql, expected] of checks) {
  const { rows } = await client.query(sql);
  const v = rows[0].v;
  const ok = expected === null || v === expected;
  if (!ok) failed++;
  console.log(`${ok ? 'ok  ' : 'FAIL'}  ${label.padEnd(18)} ${v}${expected !== null ? ` (expected ${expected})` : ''}`);
}

// Invariants that matter more than any count.
const invariants = [
  ['every public table has RLS enabled',
   `select coalesce(string_agg(relname, ', '), '') v from pg_class c
    join pg_namespace n on n.oid = c.relnamespace
    where n.nspname='public' and c.relkind='r' and not c.relrowsecurity`],
  ['anon holds no table privileges',
   `select coalesce(string_agg(distinct table_name, ', '), '') v
    from information_schema.role_table_grants where grantee='anon' and table_schema='public'`],
  ['authenticated cannot UPDATE workouts.score',
   `select coalesce(string_agg(privilege_type, ', '), '') v from information_schema.column_privileges
    where grantee='authenticated' and table_name='workouts' and column_name='score' and privilege_type='UPDATE'`],
  ['authenticated cannot UPDATE profiles.creatine_balance',
   `select coalesce(string_agg(privilege_type, ', '), '') v from information_schema.column_privileges
    where grantee='authenticated' and table_name='profiles' and column_name='creatine_balance' and privilege_type='UPDATE'`],
  ['creatine cache matches the ledger',
   `select coalesce(string_agg(p.id::text, ', '), '') v from public.profiles p
    left join (select user_id, sum(delta)::int s from public.creatine_ledger group by 1) l on l.user_id = p.id
    where p.creatine_balance <> coalesce(l.s, 0)`],
];

for (const [label, sql] of invariants) {
  const { rows } = await client.query(sql);
  const ok = rows[0].v === '';
  if (!ok) failed++;
  console.log(`${ok ? 'ok  ' : 'FAIL'}  ${label}${ok ? '' : ` -> ${rows[0].v}`}`);
}

await client.end();
console.log(failed === 0 ? '\nAll checks passed.' : `\n${failed} check(s) FAILED.`);
process.exit(failed === 0 ? 0 : 1);
