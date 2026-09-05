# HavuGym Crew

A private shared gym log for a group of friends — a *havura*.

You and your crew log workouts into one feed. The app scores each session
against **your own** trailing baseline, so a beginner's hard session and a
veteran's hard session land on the same scale. Every week the crew gets a
cooperative challenge and a competitive ranking, both of which pay out in
**creatine** — the in-app currency, which you can also buy with real money.

**Live:** <https://havugym-crew.vercel.app>

Built for *Internet Technologies*, RUNI CS 2026.
Everything required for the submission is indexed in **[SUBMISSION.md](./SUBMISSION.md)**.

### Try it

A demo crew with three weeks of history is seeded. Sign in as any member:

| Email | Password |
|---|---|
| `dana@havugym-demo.com` | `DemoCrew2026!` |
| `itay@havugym-demo.com` | `DemoCrew2026!` |
| `maya@havugym-demo.com` | `DemoCrew2026!` |
| `noam@havugym-demo.com` | `DemoCrew2026!` |

Or join their crew with invite code **`DEMO01`**.

---

## Stack

| Layer | Choice |
|---|---|
| Framework | Next.js 16 (App Router, React Server Components) |
| Language | TypeScript, `strict` |
| Database | Supabase (PostgreSQL) with Row Level Security |
| Auth | Supabase Auth (email + password) |
| Payments | Stripe Checkout, test mode |
| Styling | Tailwind CSS v4 |
| Unit / integration tests | Vitest |
| End-to-end tests | Playwright |
| Hosting | Vercel (`fra1`, co-located with the database region) |

---

## Running it locally

### 1. Prerequisites

- Node.js 20 or newer (developed on 24)
- A Supabase project
- A Stripe account in **test mode**
- The Supabase CLI: `npm i -g supabase`

### 2. Install

```bash
git clone https://github.com/Ronbeker/havugym-crew.git
cd havugym-crew
npm install
```

### 3. Environment

```bash
cp .env.example .env.local
```

Then fill in `.env.local`:

| Variable | Where it comes from | Exposed to the browser? |
|---|---|---|
| `NEXT_PUBLIC_SUPABASE_URL` | Supabase → Settings → API → Project URL | Yes |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Supabase → Settings → API → anon key | Yes |
| `SUPABASE_SERVICE_ROLE_KEY` | Supabase → Settings → API → service_role | **No — server only** |
| `SUPABASE_DB_PASSWORD` | Chosen at project creation | No — CLI only |
| `STRIPE_SECRET_KEY` | Stripe → Developers → API keys (`sk_test_…`) | **No — server only** |
| `NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY` | Stripe → Developers → API keys (`pk_test_…`) | Yes |
| `STRIPE_WEBHOOK_SECRET` | Printed by `stripe listen` (`whsec_…`) | **No — server only** |
| `NEXT_PUBLIC_SITE_URL` | `http://localhost:3000` in development | Yes |

The `NEXT_PUBLIC_` prefix is the whole distinction: those values are compiled
into the browser bundle and are readable by anyone with devtools open. The
anon key is safe there because it carries no authority of its own — every
request it makes is still filtered by Row Level Security. The service-role key
bypasses RLS entirely and must never appear in a Client Component.

### 4. Database

```bash
supabase link --project-ref <your-project-ref>
supabase db push
```

This applies, in order:

| Migration | Contents |
|---|---|
| `0001_schema.sql` | Enums, 14 tables, constraints, indexes |
| `0002_rls.sql` | Grants and Row Level Security policies |
| `0003_functions.sql` | The write path — every RPC and trigger |
| `0004_seed_exercises.sql` | 660-exercise catalogue |
| `0005_seed_shop.sql` | Cosmetic shop catalogue |

### 5. Run

```bash
npm run dev
```

To exercise the payment flow locally you also need the Stripe CLI forwarding
webhooks to the dev server:

```bash
stripe listen --forward-to localhost:3000/api/stripe/webhook
```

Copy the `whsec_…` it prints into `STRIPE_WEBHOOK_SECRET`.

### 6. Tests

```bash
npm run test        # Vitest — unit + integration
npm run test:e2e    # Playwright — end-to-end
```

---

## Documentation

The graded documents live in [`docs/`](./docs):

| § | Document | File |
|---|---|---|
| 2 | מסמך אפיון מוצר | [`docs/01-product-spec.md`](./docs/01-product-spec.md) |
| 3–4 | ארכיטקטורה ותכנון טכני | [`docs/02-technical-design.md`](./docs/02-technical-design.md) |
| 6 | מסמך אפיון בדיקות | [`docs/03-test-spec.md`](./docs/03-test-spec.md) |
| 8 | סקייל בסיסי | [`docs/04-scale.md`](./docs/04-scale.md) |
| 9 | אבטחה בסיסית | [`docs/05-security.md`](./docs/05-security.md) |
| 11 | Internal technical reference | [`docs/explainer.html`](./docs/explainer.html) · [published](https://claude.ai/code/artifact/10857557-e5ce-4a9b-9bbd-cf8cb4e50823) |
| 12 | מצגת (10–15 דקות) | [`docs/presentation.html`](./docs/presentation.html) · [published](https://claude.ai/code/artifact/d62d286c-978f-4a23-84f3-5a4da66fb3f0) |

Both HTML documents open in any browser. The presentation is keyboard-driven —
arrow keys or space to advance, `Home` / `End` to jump.

## Tests

```bash
npm test                 # 77 unit — pure domain logic, offline
npm run test:integration # 35 against the real database, incl. 22 RLS attacks
npm run test:e2e         #  6 end-to-end against the live deployment
npm run db:verify        # 12 schema invariants the security doc claims
```
