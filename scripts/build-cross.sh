#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="${1:-$ROOT/build-win32-cross}"
mkdir -p "$OUT/imports"

cat > "$OUT/imports/kernel32.def" <<'DEF'
LIBRARY KERNEL32.dll
EXPORTS
    CloseHandle
    CreateThread
    DisableThreadLibraryCalls
    GetCurrentProcessId
    InterlockedCompareExchange
    InterlockedExchange
    Sleep
DEF

cat > "$OUT/imports/user32.def" <<'DEF'
LIBRARY USER32.dll
EXPORTS
    ClientToScreen
    ClipCursor
    EnumWindows
    GetClassNameW
    GetClientRect
    GetClipCursor
    GetForegroundWindow
    GetWindow
    GetWindowThreadProcessId
    IsIconic
    IsWindow
    IsWindowVisible
DEF

cat > "$OUT/plugin_exports.def" <<'DEF'
LIBRARY pd2_cursor_capture
EXPORTS
    MODULE_LICENCE_DECLARATION DATA
    MODULE_SOURCE_CODE_LOCATION DATA
    MODULE_SOURCE_CODE_REVISION DATA
    SBLT_API_REVISION DATA
    SuperBLT_Plugin_Setup
    SuperBLT_Plugin_Init_State
    SuperBLT_Plugin_PushLua
    SuperBLT_Plugin_Update
DEF

lld-link /lib /def:"$OUT/imports/kernel32.def" /machine:x86 /out:"$OUT/imports/kernel32.lib"
lld-link /lib /def:"$OUT/imports/user32.def" /machine:x86 /out:"$OUT/imports/user32.lib"

clang --target=i686-pc-windows-msvc -O2 -ffreestanding -fno-stack-protector \
  -I"$ROOT/include" \
  -c "$ROOT/src/cursor_policy.c" -o "$OUT/cursor_policy.obj"
clang --target=i686-pc-windows-msvc -O2 -ffreestanding -fno-stack-protector \
  -I"$ROOT/include" \
  -c "$ROOT/src/plugin.c" -o "$OUT/plugin.obj"
clang --target=i686-pc-windows-msvc -c "$ROOT/src/winapi_aliases.s" -o "$OUT/winapi_aliases.obj"

lld-link /dll /machine:x86 /nodefaultlib /safeseh:no /entry:DllMain@12 \
  /def:"$OUT/plugin_exports.def" /out:"$OUT/pd2_cursor_capture.dll" \
  "$OUT/plugin.obj" "$OUT/cursor_policy.obj" "$OUT/winapi_aliases.obj" \
  "$OUT/imports/kernel32.lib" "$OUT/imports/user32.lib"

echo "Built $OUT/pd2_cursor_capture.dll"
