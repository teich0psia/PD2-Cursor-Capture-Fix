#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DLL="${1:-$ROOT/build-win32-cross/pd2_cursor_capture.dll}"
STAGE="$ROOT/dist/stage"
OUT="$ROOT/dist/PD2-Cursor-Capture-Fix.zip"
rm -rf "$STAGE"
mkdir -p "$STAGE/native" "$ROOT/dist"
cp "$ROOT/packaging/mod/mod.txt" "$ROOT/packaging/mod/supermod.xml" "$ROOT/README.md" "$ROOT/README.ja.md" "$ROOT/CHANGELOG.md" "$ROOT/LICENSE" "$STAGE/"
cp "$DLL" "$STAGE/native/pd2_cursor_capture.dll"
(cd "$STAGE" && zip -qr "$OUT" .)
echo "Packaged $OUT"
