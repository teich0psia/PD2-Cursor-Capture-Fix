# PD2 Cursor Capture Fix

[English](README.md)

PAYDAY 2のプレイ中、Windowsのマウスカーソルがゲームウィンドウの外へ出ないようにするSuperBLT MODです。

主にマルチモニター環境で、PAYDAY 2を操作している最中にマウスカーソルが別のモニターへ移動し、ブラウザやDiscordなどへ意図せずマウスホイール入力が送られてしまう問題を防ぎます。

> [!IMPORTANT]
> **Diesel 3.0について:** Diesel 3.0 Open Betaでは、この問題はゲーム本体で修正されています。そのため、本MODはDiesel 3.0では必要ありません。Steam安定版がDiesel 3.0へ移行するまで、現在の32ビット版Steam安定版向けにのみ提供しています。

## 主な機能

- PAYDAY 2がアクティブな間、カーソルをゲームウィンドウ内に固定します。
- メニュー、ロビー、装備画面、設定画面、ゲームプレイ中のいずれでも動作します。
- Alt+Tab、ゲームの最小化、別アプリへの切り替えを行うと、カーソルを自動的に解放します。
- ウィンドウの移動や、解像度・表示モードの変更後には固定範囲を再計算します。
- マウスホイール入力の遮断や、低レベルマウスフックは使用しません。
- 設定やキー割り当ては不要です。

## 動作環境

- PAYDAY 2 Steam安定版
- Windows
- [SuperBLT](https://superblt.znix.xyz/)

## ダウンロード

[最新のリリースページ](https://github.com/teich0psia/PD2-Cursor-Capture-Fix/releases/latest)から`PD2-Cursor-Capture-Fix.zip`をダウンロードしてください。

GitHubが自動生成する「Source code」のZIPやtar.gzには、すぐに使えるMOD本体が含まれていません。自分でビルドする場合を除き、ダウンロードしないでください。

## インストール

1. SuperBLTをまだ導入していない場合は、先にインストールします。
2. `PD2-Cursor-Capture-Fix.zip`をダウンロードします。
3. ZIPを`PAYDAY 2/mods/PD2-Cursor-Capture-Fix/`へ展開します。
   - 7-ZipやWinRARを使用する場合は、**`PD2-Cursor-Capture-Fix\`に展開**を選択します。
   - Windowsの**すべて展開**を使用する場合は、展開先に`PAYDAY 2/mods/PD2-Cursor-Capture-Fix/`を指定します。
4. PAYDAY 2を再起動します。

ZIPの直下には`mod.txt`、`supermod.xml`、`native/`が入っています。正しくインストールすると、次のようなフォルダ構成になります。

```text
PAYDAY 2/
└─ mods/
   └─ PD2-Cursor-Capture-Fix/
      ├─ mod.txt
      ├─ supermod.xml
      └─ native/
         └─ pd2_cursor_capture.dll
```

ZIP内のファイルを`mods`フォルダの直下へ展開しないでください。`mod.txt`は`PD2-Cursor-Capture-Fix`フォルダ内に置く必要があります。

## 使い方

設定やキー割り当てはありません。

PAYDAY 2の起動時に自動的に読み込まれます。PAYDAY 2のウィンドウがアクティブで、最小化されていない間だけカーソルを固定します。別のアプリへ切り替えると、自動的にカーソルを解放します。

## アンインストール

PAYDAY 2を終了してから、次のフォルダを削除してください。

```text
PAYDAY 2/mods/PD2-Cursor-Capture-Fix
```

## トラブルシューティング

### MODが読み込まれない

- SuperBLTが正しく導入され、動作していることを確認してください。
- `mod.txt`が`mods/PD2-Cursor-Capture-Fix/`の直下にあることを確認してください。
- MODフォルダ内に`native/pd2_cursor_capture.dll`があることを確認してください。
- MODのインストールや更新後は、ゲームを再起動してください。

### カーソルが別のモニターへ移動してしまう

- PAYDAY 2が最前面のアクティブウィンドウになっていることを確認してください。
- カーソル固定ツール、オーバーレイ、リモートデスクトップ、マルチモニター補助ツールなどを一時的に無効にし、競合していないか確認してください。
- Issueを作成する際は、PAYDAY 2の表示モードと解像度、Windowsの表示倍率、モニターの配置を記載してください。

### 別のアプリへ切り替えてもカーソルが解放されない

PAYDAY 2を終了し、ほかのカーソル固定アプリが動作していないか確認してください。問題を報告する際は、表示モードに加えて、Alt+Tabや最小化など、ゲーム画面から切り替えた方法も記載してください。

## 互換性について

- 配布しているDLLは、SuperBLT向けの32ビットWindowsネイティブモジュールです。
- カーソルの固定には、Windowsの`ClipCursor()` APIを使用しています。
- システム全体のカーソル固定範囲を操作するほかのアプリと競合する可能性があります。
- 現在のリリースは、PAYDAY 2 Steam安定版で動作を確認しています。

<details>
<summary>ソースからビルドする場合</summary>

### Windows / Visual Studio

Visual Studio 2022 Build ToolsとCMakeが必要です。Win32/x86向けにビルドしてください。

```powershell
cmake -S . -B build -A Win32 -DPD2CCF_BUILD_PLUGIN=ON -DBUILD_TESTING=ON
cmake --build build --config Release --parallel
ctest --test-dir build -C Release --output-on-failure
./scripts/package.ps1 -BuildDirectory ./build
```

### Linuxでのクロスビルド

対応する`clang`、`lld-link`、Python 3、ZIPユーティリティが必要です。

```bash
./scripts/build-cross.sh
python3 scripts/verify_pe.py build-win32-cross/pd2_cursor_capture.dll
./scripts/package.sh build-win32-cross/pd2_cursor_capture.dll
```

### ポリシーテストのみを実行する場合

```bash
cmake -S . -B build-test -G Ninja -DPD2CCF_BUILD_PLUGIN=OFF -DBUILD_TESTING=ON
cmake --build build-test
ctest --test-dir build-test --output-on-failure
```

</details>

## ライセンス

GNU General Public License v3.0で公開しています。詳細は[LICENSE](LICENSE)を参照してください。
