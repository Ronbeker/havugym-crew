/**
 * scripts/build-submission.mjs — renders the graded documents to PDF.
 *
 * The canonical documents are Markdown in docs/, because that is what reviews
 * well in git. But a marker opening a .zip should not have to find a Markdown
 * viewer that handles right-to-left text, so this produces a readable PDF of
 * each one alongside the source.
 *
 * Uses the Chromium that Playwright already installed for the end-to-end tests
 * rather than adding a PDF library: the documents contain tables, code blocks
 * and mixed RTL/LTR runs, and a browser is the only thing that lays all three
 * out correctly without an argument.
 *
 *   node scripts/build-submission.mjs
 */
import { chromium } from '@playwright/test';
import { marked } from 'marked';
import { mkdir, readFile, readdir, writeFile } from 'node:fs/promises';
import { fileURLToPath } from 'node:url';
import path from 'node:path';

const root = path.dirname(path.dirname(fileURLToPath(import.meta.url)));
const docsDir = path.join(root, 'docs');
const outDir = path.join(root, 'submission-pdf');

/** Hebrew body text, Latin code. Both need to be right in the same document. */
const STYLE = `
  @page { size: A4; margin: 18mm 16mm 20mm; }

  :root {
    --ink: #16171a;
    --muted: #5f6169;
    --rule: #d9d7d0;
    --accent: #35601b;
    --code-bg: #f4f3ee;
  }

  * { box-sizing: border-box; }

  body {
    font-family: "Heebo", "Arial Hebrew", "Noto Sans Hebrew", Arial, sans-serif;
    font-size: 10.5pt;
    line-height: 1.65;
    color: var(--ink);
    direction: rtl;
    text-align: right;
    margin: 0;
  }

  h1 {
    font-size: 22pt; font-weight: 800; line-height: 1.2;
    margin: 0 0 6pt; padding-bottom: 8pt;
    border-bottom: 2pt solid var(--ink);
  }
  h2 {
    font-size: 14pt; font-weight: 700;
    margin: 20pt 0 6pt; padding-bottom: 3pt;
    border-bottom: 0.6pt solid var(--rule);
    break-after: avoid;
  }
  h3 { font-size: 11.5pt; font-weight: 700; margin: 14pt 0 4pt; break-after: avoid; }
  p  { margin: 0 0 8pt; }

  /* Blockquotes carry the standfirst on most of these documents. */
  blockquote {
    margin: 0 0 14pt; padding: 8pt 12pt;
    border-right: 3pt solid var(--accent);
    background: #f7f8f4; color: var(--muted);
  }
  blockquote p:last-child { margin-bottom: 0; }

  /* Code is always left-to-right, inside a right-to-left document. */
  code {
    font-family: "SF Mono", Menlo, Consolas, monospace;
    font-size: 9pt; direction: ltr; unicode-bidi: embed;
    background: var(--code-bg); padding: 1pt 3pt; border-radius: 2pt;
  }
  pre {
    font-family: "SF Mono", Menlo, Consolas, monospace;
    font-size: 8.5pt; line-height: 1.5;
    direction: ltr; text-align: left; unicode-bidi: embed;
    background: var(--code-bg);
    border: 0.6pt solid var(--rule);
    border-left: 2.5pt solid var(--accent);
    padding: 8pt 10pt; margin: 0 0 10pt;
    white-space: pre-wrap; word-wrap: break-word;
    break-inside: avoid;
  }
  pre code { background: none; padding: 0; font-size: inherit; }

  table {
    width: 100%; border-collapse: collapse;
    font-size: 9pt; margin: 0 0 12pt;
    break-inside: avoid;
  }
  th, td {
    border: 0.6pt solid var(--rule);
    padding: 4pt 6pt; text-align: right; vertical-align: top;
  }
  th { background: #f4f3ee; font-weight: 700; }

  ul, ol { margin: 0 0 10pt; padding-right: 18pt; padding-left: 0; }
  li { margin-bottom: 3pt; }

  strong { font-weight: 700; }
  hr { border: 0; border-top: 0.6pt solid var(--rule); margin: 16pt 0; }
  a { color: var(--accent); text-decoration: none; }

  h2, h3, table, pre { page-break-inside: avoid; }
`;

const page = (title, body) => `<!doctype html>
<html lang="he" dir="rtl"><head><meta charset="utf-8"><title>${title}</title>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Heebo:wght@400;700;800&display=swap">
<style>${STYLE}</style></head><body>${body}</body></html>`;

async function main() {
  await mkdir(outDir, { recursive: true });

  const files = (await readdir(docsDir))
    .filter((f) => f.endsWith('.md'))
    .sort();

  const browser = await chromium.launch();
  const tab = await browser.newPage();

  for (const file of files) {
    const md = await readFile(path.join(docsDir, file), 'utf8');
    const title = (md.match(/^#\s+(.+)$/m) ?? [, file])[1];
    const html = page(title, marked.parse(md));

    await tab.setContent(html, { waitUntil: 'networkidle' });

    const pdf = file.replace(/\.md$/, '.pdf');
    await tab.pdf({
      path: path.join(outDir, pdf),
      format: 'A4',
      printBackground: true,
      displayHeaderFooter: true,
      headerTemplate: '<div></div>',
      footerTemplate:
        '<div style="width:100%;font-size:8pt;color:#8a8c93;padding:0 16mm;' +
        'font-family:Arial,sans-serif;text-align:center;">' +
        '<span class="pageNumber"></span> / <span class="totalPages"></span></div>',
      margin: { top: '18mm', bottom: '20mm', left: '16mm', right: '16mm' },
    });
    console.log(`  ${pdf.padEnd(28)} ${title}`);
  }

  await browser.close();
  console.log(`\n${files.length} documents rendered to submission-pdf/`);
}

main().catch((err) => { console.error(err); process.exit(1); });
