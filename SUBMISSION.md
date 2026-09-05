# הגשה — HavuGym Crew

> **Internet Technologies · RUNI CS 2026 · תרגיל סיום**
> מגיש: רון בקר · הגשה: 6 בספטמבר 2026

---

## הקישורים

| | |
|---|---|
| **האפליקציה באוויר** | <https://havugym-crew.vercel.app> |
| **GitHub** | <https://github.com/Ronbeker/havugym-crew> |
| **בדיקת בריאות הפריסה** | <https://havugym-crew.vercel.app/api/health> |

### כניסה מהירה למוצר

חבורת דמו עם שלושה שבועות של היסטוריה כבר קיימת במערכת:

| אימייל | סיסמה |
|---|---|
| `dana@havugym-demo.com` | `DemoCrew2026!` |
| `itay@havugym-demo.com` | `DemoCrew2026!` |
| `maya@havugym-demo.com` | `DemoCrew2026!` |
| `noam@havugym-demo.com` | `DemoCrew2026!` |

אפשר גם להירשם עם כל כתובת ולהצטרף לחבורה עם קוד ההזמנה **`DEMO01`**.

**מסלול מומלץ להתרשמות:**
`/feed` (המלצה + אימונים מדורגים) ← `/crew` (אתגר, תחרות, קופה שמתחלקת ל-350/100/50) ←
`/log` (חיפוש בקטלוג של 660 תרגילים, ציון חזוי שמתעדכן חי) ← `/shop` ← `/me` (ה-ledger)

---

## מה נדרש להגיש — ואיפה זה נמצא

| # | הנדרש בבריף | היכן |
|---|---|---|
| 1 | קישור לאפליקציה ב-Vercel | <https://havugym-crew.vercel.app> |
| 2 | קישור ל-GitHub repository | <https://github.com/Ronbeker/havugym-crew> |
| 3 | מסמך אפיון מוצר | [`docs/01-product-spec.md`](./docs/01-product-spec.md) |
| 4 | מסמך תכנון טכני | [`docs/02-technical-design.md`](./docs/02-technical-design.md) |
| 5 | מסמך אפיון בדיקות | [`docs/03-test-spec.md`](./docs/03-test-spec.md) |
| 6 | קוד הבדיקות | [`tests/`](./tests) · [`e2e/`](./e2e) — 118 בדיקות |
| 7 | מסמך סקייל בסיסי | [`docs/04-scale.md`](./docs/04-scale.md) |
| 8 | מסמך אבטחה בסיסית | [`docs/05-security.md`](./docs/05-security.md) |
| 9 | הוראות הרצה מקומית | [`README.md`](./README.md) · וגם למטה |
| 10 | מצגת (10–15 דקות) | [`docs/presentation.html`](./docs/presentation.html) |
| — | מסמך פנימי (סעיף 11, מומלץ בבריף) | [`docs/explainer.html`](./docs/explainer.html) |

שני קבצי ה-HTML נפתחים בכל דפדפן. המצגת מונעת במקלדת: חיצים או רווח להתקדמות, `Home` / `End` לקפיצה.

---

## הרצה מקומית

### דרישות
Node.js 20 ומעלה · חשבון Supabase · Supabase CLI

### שלבים

```bash
git clone https://github.com/Ronbeker/havugym-crew.git
cd havugym-crew
npm install
cp .env.example .env.local     # ואז למלא — ראו הטבלה למטה
npx supabase link --project-ref <PROJECT_REF>
npx supabase db push           # מריץ את 8 המיגרציות לפי הסדר
npm run dev                    # http://localhost:3000
```

### משתני הסביבה

| משתנה | מקור | נחשף לדפדפן? |
|---|---|---|
| `NEXT_PUBLIC_SUPABASE_URL` | Supabase → Settings → API | כן |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Supabase → Settings → API | כן |
| `SUPABASE_SERVICE_ROLE_KEY` | Supabase → Settings → API | **לא — שרת בלבד** |
| `SUPABASE_DB_URL` | מחרוזת חיבור ה-pooler | לא — CLI ובדיקות |
| `NEXT_PUBLIC_SITE_URL` | `http://localhost:3000` בפיתוח | כן |
| `STRIPE_SECRET_KEY` | Stripe → API keys (`sk_test_`) | **לא — שרת בלבד** |
| `NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY` | Stripe → API keys (`pk_test_`) | כן |
| `STRIPE_WEBHOOK_SECRET` | פלט של `stripe listen` | **לא — שרת בלבד** |

**התחילית `NEXT_PUBLIC_` היא כל ההבדל:** ערכים כאלה מהודרים לתוך ה-bundle של הדפדפן וגלויים לכל
מי שפותח devtools. מפתח ה-anon בטוח שם כי אין לו סמכות משלו — כל בקשה שלו עדיין עוברת דרך RLS.
מפתח ה-service role עוקף RLS לחלוטין, ולכן לעולם אינו נושא את התחילית הזו.

Stripe אופציונלי: בלי המפתחות החנות עובדת במלואה, ורק אזור רכישת החבילות אינו מוצג.

### הרצת הבדיקות

```bash
npm test                   # 77 unit — לוגיקה טהורה, ללא רשת
npm run test:integration   # 35 מול המסד האמיתי (22 מהן תקיפות הרשאה)
npm run test:e2e           #  6 מקצה לקצה מול הפריסה החיה
npm run db:verify          # 12 אינווריאנטים של הסכמה
npm run test:all           # הכול
```

---

## המערכת בקצרה

| | |
|---|---|
| Framework | Next.js 16 — App Router, React Server Components |
| שפה | TypeScript, `strict` |
| מסד נתונים | Supabase / PostgreSQL — 14 טבלאות, 2 views, **20 RLS policies**, 13 functions |
| אימות | Supabase Auth (אימייל וסיסמה) |
| תשלומים | Stripe Checkout, test mode |
| עיצוב | Tailwind CSS v4 |
| בדיקות | Vitest · Playwright — **118 בדיקות** |
| אירוח | Vercel, אזור `fra1` — באותו אזור כמו המסד |

### שלוש נקודות שכדאי להסתכל עליהן

**1. ההרשאות חיות במסד, לא באפליקציה.**
שאילתה ששכחו בה סינון מחזירה **אפס שורות**, לא את כולן. אותה טעות בדיוק היא פרצה במערכת רגילה
ובאג ריק כאן. ניתן לאימות מיידי:

```bash
curl -s https://havugym-crew.vercel.app/api/health | jq .rls
# { "anonReadStatus": 401, "anonIsDenied": true }
```

**2. הציון נמדד מול המתאמן, לא מול הברזל.**
חציון על 8 האימונים הקודמים שלו. יום רגיל ≈ 50 לכל אחד, יום קשה ≈ 90 לכל אחד — וזה מה שהופך
טבלת דירוג משותפת בין מתחיל לוותיק למשהו בעל משמעות.

**3. המסמכים אומרים אמת, ויש בדיקה שמוודאת זאת.**
`npm run db:verify` מאמת את 12 האינווריאנטים שמסמך האבטחה טוען להם — שRLS פעיל בכל טבלה,
של-`anon` אין הרשאות, שאין UPDATE על `score` ועל היתרה, ושה-cache שווה ל-ledger.

---

## מה לא נבנה, ולמה

הבריף מבקש מוצר קטן ובנוי טוב ולא מוצר גדול ומבולגן. הגבולות שנבחרו מפורטים ב-
[`docs/01-product-spec.md §7`](./docs/01-product-spec.md), והמגבלות הידועות — כולל אחת שנמצאה
במדידה ולא תוקנה במכוון — ב-[`docs/04-scale.md §3, §11`](./docs/04-scale.md).
