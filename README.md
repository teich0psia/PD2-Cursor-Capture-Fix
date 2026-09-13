# PD2 Cursor Capture Fix

[日本語](README.ja.md)

A SuperBLT mod for PAYDAY 2 that keeps the mouse cursor captured by the game while playing, preventing it from escaping to another monitor on multi-monitor setups.

## Requirements

- PAYDAY 2 (Diesel 3.0 / 64-bit)
- SuperBLT

For the older Diesel 2.0 / 32-bit version, use the [`legacy-diesel2`](https://github.com/teich0psia/PD2-Cursor-Capture-Fix/tree/legacy-diesel2) branch.

## Installation

1. Download or clone this repository.
2. Place the `PD2-Cursor-Capture-Fix` folder in:

```text
PAYDAY 2/mods/
```

The installed files should look like this:

```text
PAYDAY 2/
└─ mods/
   └─ PD2-Cursor-Capture-Fix/
      ├─ mod.txt
      ├─ lua/
      │  ├─ main.lua
      │  └─ menu.lua
      ├─ menu/
      │  └─ options.json
      └─ loc/
         ├─ en.txt
         └─ ja.txt
```

3. Start or restart PAYDAY 2.

## Settings

Open **Options → Mod Options → PD2 Cursor Capture Fix**.

**High polling rate mouse support** is disabled by default. Enable it if the cursor can still escape with a 4000 Hz or 8000 Hz mouse. When enabled, the mod reinforces the mouse lock at additional points during each frame. The setting applies immediately and is saved between launches.

## License

MIT License. See [LICENSE](LICENSE).
