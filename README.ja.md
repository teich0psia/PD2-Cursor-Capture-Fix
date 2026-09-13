# PD2 Cursor Capture Fix

[English](README.md)

PAYDAY 2のプレイ中にマウスカーソルをゲーム側へ固定し、マルチモニター環境で別のモニターへカーソルが抜ける問題を抑えるSuperBLT MODです。

## 動作環境

- PAYDAY 2（Diesel 3.0 / 64ビット）
- SuperBLT

旧Diesel 2.0 / 32ビット版は [`legacy-diesel2`](https://github.com/teich0psia/PD2-Cursor-Capture-Fix/tree/legacy-diesel2) ブランチにあります。

## インストール

1. このリポジトリをダウンロードまたはcloneします。
2. `PD2-Cursor-Capture-Fix` フォルダを以下へ配置します。

```text
PAYDAY 2/mods/
```

配置後は次の構成になります。

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

3. PAYDAY 2を起動、または再起動します。

## 設定

**オプション → Mod Options → PD2 Cursor Capture Fix** から設定できます。

**高ポーリングレートマウス対応** は初期状態では無効です。4000 Hz / 8000 Hzなどのマウスでカーソルが抜ける場合に有効にしてください。有効にすると、1フレーム内の追加タイミングでもマウスロックを再適用します。設定は即時反映され、次回起動時にも保持されます。

## ライセンス

MIT License。詳細は [LICENSE](LICENSE) を参照してください。
