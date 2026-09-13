# PD2 Cursor Capture Fix

[日本語](README.ja.md)

A small SuperBLT mod for PAYDAY 2 that keeps the Windows mouse cursor inside the game window while the game is active.

This is mainly useful on multi-monitor setups. It prevents mouse-wheel input from reaching another window, such as a browser or Discord, while you are using PAYDAY 2.

> [!IMPORTANT]
> **Diesel 3.0:** The Diesel 3.0 Open Beta fixes this cursor and mouse-wheel issue in the game itself. This mod is not needed on Diesel 3.0. It is provided only for the current 32-bit Steam Stable build until the stable branch moves to Diesel 3.0.

## Features

- Keeps the cursor inside the PAYDAY 2 client area while the game is focused.
- Works in menus, lobbies, loadout screens, settings, and gameplay.
- Releases the cursor when you Alt+Tab, minimize the game, or switch to another application.
- Recalculates the capture area after moving the window or changing the resolution or display mode.
- Does not block mouse-wheel events or install a low-level mouse hook.
- Requires no configuration.

## Requirements

- PAYDAY 2 on Steam Stable
- Windows
- [SuperBLT](https://superblt.znix.xyz/)

## Download

Download `PD2-Cursor-Capture-Fix.zip` from the [latest release page](https://github.com/teich0psia/PD2-Cursor-Capture-Fix/releases/latest).

Do not download the automatically generated GitHub source archives unless you intend to build the mod yourself.

## Installation

1. Install SuperBLT if it is not already installed.
2. Download `PD2-Cursor-Capture-Fix.zip`.
3. Extract the archive into `PAYDAY 2/mods/PD2-Cursor-Capture-Fix/`.
   - With 7-Zip or WinRAR, use **Extract to `PD2-Cursor-Capture-Fix\`**.
   - With Windows **Extract All**, select `PAYDAY 2/mods/PD2-Cursor-Capture-Fix/` as the destination.
4. Restart PAYDAY 2.

The ZIP contains `mod.txt`, `supermod.xml`, and `native/` directly at its root. The installed files should look like this:

```text
PAYDAY 2/
└─ mods/
   └─ PD2-Cursor-Capture-Fix/
      ├─ mod.txt
      ├─ supermod.xml
      └─ native/
         └─ pd2_cursor_capture.dll
```

Do not extract the files directly into the `mods` folder itself. `mod.txt` must be inside the `PD2-Cursor-Capture-Fix` folder.

## Usage

There are no settings or keybinds.

The mod starts automatically when PAYDAY 2 loads. The cursor is captured only while the PAYDAY 2 window is active and not minimized. Switching to another application releases it automatically.

## Uninstallation

Close PAYDAY 2 and delete:

```text
PAYDAY 2/mods/PD2-Cursor-Capture-Fix
```

## Troubleshooting

### The mod does not load

- Confirm that SuperBLT is installed and working.
- Confirm that `mod.txt` is directly inside `mods/PD2-Cursor-Capture-Fix/`.
- Confirm that `native/pd2_cursor_capture.dll` exists inside the mod folder.
- Restart the game after installing or replacing the mod.

### The cursor still reaches another monitor

- Make sure PAYDAY 2 is the active foreground window.
- Temporarily disable other cursor-locking, overlay, remote-desktop, or multi-monitor utilities to check for conflicts.
- Report the PAYDAY 2 display mode, resolution, Windows scaling, and monitor arrangement when opening an issue.

### The cursor is not released after switching applications

Close PAYDAY 2 and check whether another cursor-locking application is running. When reporting the problem, include the display mode and the action used to leave the game, such as Alt+Tab or minimizing.

## Compatibility notes

- The distributed plugin is a 32-bit Windows native module for SuperBLT.
- The mod uses the Windows `ClipCursor()` API.
- Other applications that also control the system cursor capture area may conflict with it.
- The current release has been tested with PAYDAY 2 Steam Stable.

<details>
<summary>Building from source</summary>

### Windows / Visual Studio

Visual Studio 2022 Build Tools and CMake are required. Build for Win32/x86.

```powershell
cmake -S . -B build -A Win32 -DPD2CCF_BUILD_PLUGIN=ON -DBUILD_TESTING=ON
cmake --build build --config Release --parallel
ctest --test-dir build -C Release --output-on-failure
./scripts/package.ps1 -BuildDirectory ./build
```

### Linux cross-build

A compatible `clang`, `lld-link`, Python 3, and ZIP utility are required.

```bash
./scripts/build-cross.sh
python3 scripts/verify_pe.py build-win32-cross/pd2_cursor_capture.dll
./scripts/package.sh build-win32-cross/pd2_cursor_capture.dll
```

### Portable policy tests

```bash
cmake -S . -B build-test -G Ninja -DPD2CCF_BUILD_PLUGIN=OFF -DBUILD_TESTING=ON
cmake --build build-test
ctest --test-dir build-test --output-on-failure
```

</details>

## License

MIT License. See [LICENSE](LICENSE).
