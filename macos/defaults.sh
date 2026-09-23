#!/usr/bin/env bash
# macOS の設定。2026-09-23 時点の実機の値を書き出したもの。
# 各項目の意味・設定画面での場所・元に戻す方法は docs/macos.md を参照
set -euo pipefail

# iCloud Drive の「ダウンロード」フォルダ
ICLOUD_DOWNLOADS="$HOME/Library/Mobile Documents/com~apple~CloudDocs/ダウンロード"

# --- キーボード・入力 ---
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 2
defaults write -g NSAutomaticCapitalizationEnabled -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false

# --- 外観 ---
defaults write -g AppleInterfaceStyle -string Dark

# --- Finder ---
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.finder FXPreferredViewStyle -string Nlsv
defaults write com.apple.finder FXDefaultSearchScope -string SCcf
defaults write com.apple.finder NewWindowTarget -string PfLo
# パスは URL 形式。日本語フォルダ名はパーセントエンコードする
defaults write com.apple.finder NewWindowTargetPath -string \
  "file://${HOME}/Library/Mobile%20Documents/com~apple~CloudDocs/%E3%82%BF%E3%82%99%E3%82%A6%E3%83%B3%E3%83%AD%E3%83%BC%E3%83%88%E3%82%99/"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# --- Dock ---
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 48
defaults write com.apple.dock orientation -string left

# --- スクリーンショット ---
mkdir -p "$ICLOUD_DOWNLOADS"
defaults write com.apple.screencapture location -string "$ICLOUD_DOWNLOADS"

# 設定を反映するため関連プロセスを再起動する
for app in Finder Dock SystemUIServer; do
  killall "$app" >/dev/null 2>&1 || true
done
echo "    キーリピートとダークモードは、ログアウトして入り直すと確実に反映されます"
