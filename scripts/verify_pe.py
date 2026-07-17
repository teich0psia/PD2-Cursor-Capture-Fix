#!/usr/bin/env python3
from __future__ import annotations
import pathlib, struct, subprocess, sys

REQUIRED_EXPORTS = {
    "MODULE_LICENCE_DECLARATION",
    "MODULE_SOURCE_CODE_LOCATION",
    "MODULE_SOURCE_CODE_REVISION",
    "SBLT_API_REVISION",
    "SuperBLT_Plugin_Setup",
    "SuperBLT_Plugin_Init_State",
    "SuperBLT_Plugin_PushLua",
    "SuperBLT_Plugin_Update",
}

p = pathlib.Path(sys.argv[1])
data = p.read_bytes()
if data[:2] != b"MZ":
    raise SystemExit("not a PE file")
pe = struct.unpack_from("<I", data, 0x3C)[0]
if data[pe:pe+4] != b"PE\0\0":
    raise SystemExit("missing PE signature")
machine = struct.unpack_from("<H", data, pe + 4)[0]
magic = struct.unpack_from("<H", data, pe + 24)[0]
if machine != 0x14C or magic != 0x10B:
    raise SystemExit(f"expected PE32/i386, got machine={machine:#x} magic={magic:#x}")

objdump = subprocess.run(["llvm-objdump", "-p", str(p)], text=True, capture_output=True, check=True).stdout
missing = sorted(x for x in REQUIRED_EXPORTS if x not in objdump)
if missing:
    raise SystemExit("missing exports: " + ", ".join(missing))
imports = {line.strip().split()[-1].upper() for line in objdump.splitlines() if "DLL Name:" in line}
if imports - {"KERNEL32.DLL", "USER32.DLL"}:
    raise SystemExit("unexpected imports: " + ", ".join(sorted(imports)))
print("PE verification passed")
