#!/usr/bin/env bash
# Copy a Caviot Studio build into forge/ so it is served at designmainline.com/forge.
# Usage: scripts/sync-caviot.sh [path-to-caviot-studio-checkout]   (default: ../caviot-studio)
set -euo pipefail
SRC="${1:-../caviot-studio}/dist"
DEST="$(cd "$(dirname "$0")/.." && pwd)/forge"
[ -f "$SRC/index.html" ] || { echo "No Caviot Studio build at $SRC" >&2; exit 1; }
rm -rf "$DEST"
cp -R "$SRC" "$DEST"
# The app uses relative URLs; pin them to /forge/ so /forge (no trailing slash) works too.
for f in "$DEST/index.html" "$DEST/about.html"; do
  sed -i.bak -e 's#<head>#<head><base href="/forge/">#' "$f" && rm "$f.bak"
done
echo "Synced $(du -sh "$DEST" | cut -f1) into forge/"
