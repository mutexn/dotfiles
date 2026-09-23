#!/usr/bin/env bash
# macOS のセキュリティ設定。管理者権限が必要なので、途中でパスワードを聞かれる。詳細は docs/macos.md
# 何度実行しても安全（すでに設定済みなら何もしない）
set -euo pipefail

FW=/usr/libexec/ApplicationFirewall/socketfilterfw

# --- ファイアウォール：外から Mac への接続を、許可したアプリ以外は受け付けない ---
if "$FW" --getglobalstate | grep -q 'enabled'; then
  echo "    ファイアウォール: 有効（設定済み）"
else
  sudo "$FW" --setglobalstate on >/dev/null
  echo "    ファイアウォール: 有効にした"
fi

# --- ステルスモード：外からの問い合わせ（ping など）に応答せず、ネットワーク上で見つかりにくくする ---
if "$FW" --getstealthmode | grep -qE 'enabled|is on'; then
  echo "    ステルスモード: 有効（設定済み）"
else
  sudo "$FW" --setstealthmode on >/dev/null
  echo "    ステルスモード: 有効にした"
fi

# --- Touch ID で sudo：管理者パスワードの代わりに指紋を使えるようにする ---
# /etc/pam.d/sudo_local は macOS のアップデートで消えない。macOS 付属のひな形の 1 行を有効にして作る
SUDO_LOCAL=/etc/pam.d/sudo_local
if [[ -f "$SUDO_LOCAL" ]] && grep -qE '^auth[[:space:]]+sufficient[[:space:]]+pam_tid\.so' "$SUDO_LOCAL"; then
  echo "    Touch ID で sudo: 有効（設定済み）"
elif [[ -f "$SUDO_LOCAL" ]]; then
  echo "    Touch ID で sudo: $SUDO_LOCAL が別の内容で存在するため変更しない。中身を確認して手で設定する" >&2
else
  sed 's/^#auth\([[:space:]]*sufficient[[:space:]]*pam_tid\.so\)/auth\1/' /etc/pam.d/sudo_local.template | sudo tee "$SUDO_LOCAL" >/dev/null
  echo "    Touch ID で sudo: 有効にした（次に sudo を使うときから指紋で認証できる）"
fi
