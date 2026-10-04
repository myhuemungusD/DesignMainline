#!/usr/bin/env bash
# Copy a Caviot Studio build into forge/ so it is served at designmainline.com/forge.
# Usage: scripts/sync-caviot.sh [path-to-caviot-studio-checkout]   (default: ../caviot-studio)
set -euo pipefail
REPO="${1:-../caviot-studio}"
SRC="$REPO/dist"
DEST="$(cd "$(dirname "$0")/.." && pwd)/forge"
[ -f "$SRC/index.html" ] || { echo "No Caviot Studio build at $SRC" >&2; exit 1; }
rm -rf "$DEST"
cp -R "$SRC" "$DEST"
# The app uses relative URLs; pin them to /forge/ so /forge (no trailing slash) works too.
for f in "$DEST/index.html" "$DEST/about.html"; do
  sed -i.bak -e 's#<head>#<head><base href="/forge/">#' "$f" && rm "$f.bak"
done
# Bundled fonts are for personal use only; strip them from the public copy.
node "$(dirname "$0")/public-fonts.mjs" "$DEST"
# The offline worker (sw.js) pins every file to a content hash, so rebuild it for the edited HTML using the
# app's own build script; otherwise the worker's install fails on every visit.
TMP="$(mktemp -d)"
cp "$REPO/build-sw.mjs" "$REPO/sw-template.js" "$TMP/"
ln -s "$DEST" "$TMP/dist"
node "$TMP/build-sw.mjs"
rm -rf "$TMP"
echo "Synced $(du -sh "$DEST" | cut -f1) into forge/"
