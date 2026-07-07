#!/usr/bin/env bash
#
# Rebuild pages/ from the two scanned PDFs.
#
# The scans store two-page spreads as single wide (landscape) pages and genuine
# single pages (cover, back-matter) as tall (portrait) pages. This script renders
# every page, splits the wide spreads down the gutter into left/right leaves,
# keeps the tall singles as-is, and writes an ordered set of page-NNN.jpg files.
#
# Requirements: poppler-utils (pdftoppm), python3 + Pillow.
#   Debian/Ubuntu:  sudo apt-get install poppler-utils && pip install pillow
#   macOS (brew):   brew install poppler && pip3 install pillow
#
# Usage (from the repo root):
#   ./build/build.sh PART1.pdf PART2.pdf
#
# Defaults match the original scan filenames if no args are given.

set -euo pipefail

PART1="${1:-build/part1.pdf}"
PART2="${2:-build/part2.pdf}"
DPI="${DPI:-150}"
TARGET_H="${TARGET_H:-1700}"     # output page height in px
QUALITY="${QUALITY:-82}"         # JPEG quality
SPREAD_ASPECT="${SPREAD_ASPECT:-1.3}"

here="$(cd "$(dirname "$0")/.." && pwd)"
cd "$here"

for f in "$PART1" "$PART2"; do
  [ -f "$f" ] || { echo "ERROR: cannot find $f"; echo "Pass the two PDFs: ./build/build.sh part1.pdf part2.pdf"; exit 1; }
done

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/r1" "$tmp/r2" pages
rm -f pages/page-*.jpg

echo "Rendering $PART1 at ${DPI} DPI..."
pdftoppm -jpeg -r "$DPI" "$PART1" "$tmp/r1/pg"
echo "Rendering $PART2 at ${DPI} DPI..."
pdftoppm -jpeg -r "$DPI" "$PART2" "$tmp/r2/pg"

echo "Splitting spreads and writing pages/ ..."
python3 - "$tmp/r1" "$tmp/r2" "$TARGET_H" "$QUALITY" "$SPREAD_ASPECT" <<'PY'
import sys, glob, os
from PIL import Image

r1, r2, TARGET_H, QUALITY, SPREAD = sys.argv[1], sys.argv[2], int(sys.argv[3]), int(sys.argv[4]), float(sys.argv[5])
sources = sorted(glob.glob(r1+"/*.jpg")) + sorted(glob.glob(r2+"/*.jpg"))

leaves = []
for src in sources:
    im = Image.open(src).convert("RGB")
    w, h = im.size
    if w / h > SPREAD:                      # wide spread -> split into two leaves
        mid = w // 2
        leaves.append(im.crop((0, 0, mid, h)))
        leaves.append(im.crop((mid, 0, w, h)))
    else:                                   # tall single page -> keep
        leaves.append(im)

if len(leaves) % 2:                         # keep an even count for clean spreads
    leaves.append(Image.new("RGB", leaves[-1].size, (247, 244, 236)))

for i, im in enumerate(leaves, 1):
    w, h = im.size
    if h != TARGET_H:
        im = im.resize((round(w * TARGET_H / h), TARGET_H), Image.LANCZOS)
    im.save(f"pages/page-{i:03d}.jpg", "JPEG", quality=QUALITY, optimize=True, progressive=True)

print(f"Wrote {len(leaves)} pages to pages/")
PY

echo
echo "Done. If the leaf count changed, update TOTAL in index.html (currently expects the same count)."
du -sh pages
