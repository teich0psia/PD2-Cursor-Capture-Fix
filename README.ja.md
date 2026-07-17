# PD2 Cursor Capture Fix

[English](README.md)

PAYDAY 2がアクティブな間、Windowsのマウスカーソルをゲーム画面内に収めるSuperBLT MOD。

主にマルチモニター環境向けで、PAYDAY 2を操作している最中に、ブラウザやDiscordなど別モニター上のウィンドウへマウスホイール入力が流れる問題を防ぐ。

> [!IMPORTANT]
> **Diesel 3.0について:** Diesel 3.0 Open Betaでは、このカーソル固定および別モニターへのマウスホイール入力問題はゲーム本体側で修正済み。本MODはDiesel 3.0では不要であり、Stable版がDiesel 3.0へ移行するまでの現行32-bit版Steam Stable向けにのみ提供している。

## 主な機能

- PAYDAY 2がアクティブな間、カーソルをゲームのクライアント領域内に固定する。
- メニュー、ロビー、装備画面、設定画面、ゲームプレイ中のすべてで動作する。
- Alt+Tab、最小化、別アプリへの切り替え時は自動的にカーソルを解放する。
- ウィンドウ移動、解像度変更、表示モード変更後は固定範囲を再計算する。
- マウスホイール入力自体の遮断や、低レベルマウスフックは使用しない。
- 設定やキー割り当ては不要。

## 必要環境

- PAYDAY 2 Steam Stable
- Windows
- [SuperBLT](https://superblt.znix.xyz/)

## ダウンロード

[最新のReleaseページ](https://github.com/teich0psia/PD2-Cursor-Capture-Fix/releases/latest)から`PD2-Cursor-Capture-Fix.zip`をダウンロードする。

自分でビルドする目的でなければ、GitHubが自動生成する`Source code`のZIPやtar.gzは使用しない。

## インストール

1. SuperBLTを導入していない場合は先にインストールする。
2. `PD2-Cursor-Capture-Fix.zip`をダウンロードする。
3. ZIPを`PAYDAY 2/mods/PD2-Cursor-Capture-Fix/`へ展開する。
   - 7-ZipやWinRARでは、**`PD2-Cursor-Capture-Fix\`に展開**を選ぶ。
   - Windowsの**すべて展開**では、展開先に`PAYDAY 2/mods/PD2-Cursor-Capture-Fix/`を指定する。
4. PAYDAY 2を再起動する。

ZIP直下には`mod.txt`、`supermod.xml`、`native/`が入っている。正しく配置すると以下の構成になる。

```text
PAYDAY 2/
└─ mods/
   └─ PD2-Cursor-Capture-Fix/
      ├─ mod.txt
      ├─ supermod.xml
      └─ native/
         └─ pd2_cursor_capture.dll
```

ZIP内のファイルを`mods`フォルダ直下へ直接展開しないこと。`mod.txt`は`PD2-Cursor-Capture-Fix`フォルダ内に置く必要がある。

## 使い方

設定項目やキー割り当てはない。

PAYDAY 2の起動時に自動で読み込まれる。PAYDAY 2のウィンドウがアクティブかつ最小化されていない間だけカーソルを固定し、別アプリへ切り替えると自動的に解放する。

## アンインストール

PAYDAY 2を終了し、次のフォルダを削除する。

```text
PAYDAY 2/mods/PD2-Cursor-Capture-Fix
```

## トラブルシューティング

### MODが読み込まれない

- SuperBLTが正しく導入され、他のSuperBLT MODが動作しているか確認する。
- `mod.txt`が`mods/PD2-Cursor-Capture-Fix/`直下にあるか確認する。
- MODフォルダ内に`native/pd2_cursor_capture.dll`が存在するか確認する。
- 導入や上書き後はゲームを再起動する。

### カーソルが別モニターへ出る

- PAYDAY 2が最前面のアクティブウィンドウになっているか確認する。
- カーソル固定ツール、オーバーレイ、リモートデスクトップ、マルチモニター補助ツールを一時的に無効化し、競合がないか確認する。
- Issueを作成する場合は、PAYDAY 2の表示モード、解像度、Windowsの表示倍率、モニター配置を記載する。

### 別アプリへ切り替えてもカーソルが解放されない

PAYDAY 2を終了し、他のカーソル固定アプリが動作していないか確認する。報告時は表示モードと、Alt+Tabや最小化など、ゲーム画面から離れた方法を記載する。

## 互換性に関する注意

- 配布DLLはSuperBLT向けの32-bit Windowsネイティブモジュール。
- Windowsの`ClipCursor()` APIを使用する。
- システム全体のカーソル固定領域を操作する他のアプリと競合する可能性がある。
- 現在のReleaseはPAYDAY 2 Steam Stableで確認済み。

<details>
<summary>ソースからビルドする場合</summary>

### Windows / Visual Studio

Visual Studio 2022 Build ToolsとCMakeが必要。Win32/x86向けにビルドする。

```powershell
cmake -S . -B build -A Win32 -DPD2CCF_BUILD_PLUGIN=ON -DBUILD_TESTING=ON
cmake --build build --config Release --parallel
ctest --test-dir build -C Release --output-on-failure
./scripts/package.ps1 -BuildDirectory ./build
```

### Linuxでのクロスビルド

対応する`clang`、`lld-link`、Python 3、ZIPユーティリティが必要。

```bash
./scripts/build-cross.sh
python3 scripts/verify_pe.py build-win32-cross/pd2_cursor_capture.dll
./scripts/package.sh build-win32-cross/pd2_cursor_capture.dll
```

### ポリシーテストのみ実行

```bash
cmake -S . -B build-test -G Ninja -DPD2CCF_BUILD_PLUGIN=OFF -DBUILD_TESTING=ON
cmake --build build-test
ctest --test-dir build-test --output-on-failure
```

</details>

## ライセンス

GNU General Public License v3.0。詳細は[LICENSE](LICENSE)を参照。
