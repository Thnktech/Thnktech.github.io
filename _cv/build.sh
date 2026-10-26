#!/usr/bin/env sh
# Prints the one-page CVs to the PDFs linked from the site.
# Usage (from repo root, Git Bash): sh _cv/build.sh
# Override the browser with CHROME=/path/to/chrome if it is installed elsewhere.
set -e
cd "$(dirname "$0")/.."
CHROME="${CHROME:-/c/Program Files/Google/Chrome/Application/chrome.exe}"
ROOT="$(pwd -W 2>/dev/null || pwd)"
# Separate profile so headless Chrome never hands the job to an already-open browser window
PROFILE="${TMPDIR:-/tmp}/cv-chrome-profile"

print() {
  rm -f "$2"
  "$CHROME" --headless=new --disable-gpu --no-pdf-header-footer --user-data-dir="$PROFILE" \
    --print-to-pdf="$ROOT/$2" "file:///$(echo "$ROOT/_cv/$1" | sed 's/ /%20/g')" >/dev/null 2>&1
  [ -s "$2" ] || { echo "Failed to print $2" >&2; exit 1; }
  # pdftotext ends every page with a form feed; it ships with Git for Windows
  if command -v pdftotext >/dev/null; then
    echo "$2: $(pdftotext "$2" - | tr -cd '\f' | wc -c | tr -d ' ') page(s)"
  else
    echo "$2: written"
  fi
}

print cv-en.html Muthiah_Shanmugam_Resume_EN_OnePage.pdf
print cv-de.html Muthiah_Shanmugam_CV_DE_OnePage.pdf
