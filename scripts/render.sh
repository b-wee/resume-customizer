#!/bin/bash
# render.sh <output-dir> <basename>
# Expects <output-dir>/resume.html to exist. Produces:
#   <output-dir>/<basename>.pdf   (headless Chrome)
#   <output-dir>/<basename>.docx  (pandoc)
#   <output-dir>/resume.txt       (pandoc plain text)
set -euo pipefail

DIR="${1:?usage: render.sh <output-dir> <basename>}"
BASE="${2:?usage: render.sh <output-dir> <basename>}"
HTML="$DIR/resume.html"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

[ -f "$HTML" ] || { echo "ERROR: $HTML not found" >&2; exit 1; }

# PDF via headless Chrome
"$CHROME" --headless --disable-gpu --no-pdf-header-footer \
  --print-to-pdf="$DIR/$BASE.pdf" "file://$(cd "$DIR" && pwd)/resume.html" 2>/dev/null
[ -s "$DIR/$BASE.pdf" ] || { echo "ERROR: PDF generation failed" >&2; exit 1; }
echo "PDF:  $DIR/$BASE.pdf"

# docx via pandoc
if command -v pandoc >/dev/null 2>&1; then
  pandoc "$HTML" -f html -t docx -o "$DIR/$BASE.docx"
  echo "DOCX: $DIR/$BASE.docx"
else
  echo "WARN: pandoc not installed; skipping docx (brew install pandoc)" >&2
fi

# Plain text via pandoc (fallback: textutil, ships with macOS)
if command -v pandoc >/dev/null 2>&1; then
  pandoc "$HTML" -f html -t plain -o "$DIR/resume.txt"
else
  textutil -convert txt -output "$DIR/resume.txt" "$HTML"
fi
echo "TXT:  $DIR/resume.txt"
