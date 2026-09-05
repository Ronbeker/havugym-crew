#!/usr/bin/env bash
#
# scripts/package-submission.sh — builds the drop-in submission archive.
#
# Produces havugym-crew-submission.zip containing the full source, the graded
# documents in both Markdown and PDF, and the test code — with nothing in it
# that should not be handed over.
#
# EXCLUDED, deliberately:
#   node_modules/  .next/   restored by `npm install` and `npm run build`
#   .git/                   history is on GitHub; the archive is a snapshot
#   .env.local .env.vercel  secrets, and the whole reason .env.example exists
#   test-results/ playwright-report/  transient test output
#
# Usage:  npm run package
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

NAME="havugym-crew"
OUT="$ROOT/${NAME}-submission.zip"
STAGE="$(mktemp -d)/${NAME}"

echo "› rendering documents to PDF"
npm run --silent build:submission

echo "› staging"
mkdir -p "$STAGE"

# Copy the tracked working tree, then add the generated PDFs. Using git's own
# idea of what belongs in the project means the archive can never contain
# something .gitignore already decided to keep out.
git ls-files -z | while IFS= read -r -d '' file; do
  mkdir -p "$STAGE/$(dirname "$file")"
  cp "$file" "$STAGE/$file"
done

mkdir -p "$STAGE/submission-pdf"
cp submission-pdf/*.pdf "$STAGE/submission-pdf/"

# A plain-text landing card, so the links are readable without opening anything.
cat > "$STAGE/LINKS.txt" <<TXT
HavuGym Crew — Internet Technologies, RUNI CS 2026
Ron Beker

  Live application   https://havugym-crew.vercel.app
  GitHub repository  https://github.com/Ronbeker/havugym-crew
  Deployment health  https://havugym-crew.vercel.app/api/health

Demo sign-in — password for every account: DemoCrew2026!

  dana@havugym-demo.com      itay@havugym-demo.com
  maya@havugym-demo.com      noam@havugym-demo.com
  shira@havugym-demo.com     omer@havugym-demo.com
  tamar@havugym-demo.com     yonatan@havugym-demo.com
  roni@havugym-demo.com      alon@havugym-demo.com
  gil@havugym-demo.com

  Or sign up with any address and join with invite code DEMO01.

Start with SUBMISSION.md — it maps every required deliverable to where it is.
The five graded documents are in submission-pdf/ (PDF) and docs/ (Markdown source).
TXT

echo "› zipping"
rm -f "$OUT"
( cd "$(dirname "$STAGE")" && zip -qr "$OUT" "$NAME" -x '*.DS_Store' )
rm -rf "$(dirname "$STAGE")"

echo
echo "  $OUT"
echo "  $(du -h "$OUT" | cut -f1)  ·  $(unzip -l "$OUT" | tail -1 | awk '{print $2}') files"
