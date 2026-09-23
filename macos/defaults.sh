#!/usr/bin/env bash
# macOS の設定。2026-09-23 時点の実機の値を書き出し、試用して採用した設定を加えたもの。
# 各項目の意味・設定画面での場所・元に戻す方法は docs/macos.md を参照
set -euo pipefail

# iCloud Drive の「ダウンロード」フォルダ
ICLOUD_DOWNLOADS="$HOME/Library/Mobile Documents/com~apple~CloudDocs/ダウンロード"

# --- キーボード・入力 ---
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 2
defaults write -g NSAutomaticCapitalizationEnabled -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false   # " を “ ” に変えない
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false    # -- を — に変えない
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false  # 英単語を勝手に直さない
defaults write -g ApplePressAndHoldEnabled -bool false              # 長押しで同じ文字を連続入力

# --- 外観 ---
defaults write -g AppleInterfaceStyle -string Dark

# --- Finder ---
# Finder だけ英語表示にする（フォルダ名が Documents・Downloads・Applications などになる）。システムの言語は日本語のまま
defaults write com.apple.finder AppleLanguages -array en
defaults write -g AppleShowAllExtensions -bool true                 # すべての拡張子を表示
defaults write com.apple.finder ShowPathbar -bool true              # 下部にパスバー
defaults write com.apple.finder ShowStatusBar -bool true            # 下部に状態バー（項目数・空き容量）
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false  # 拡張子変更の警告を出さない
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.finder FXPreferredViewStyle -string Nlsv
defaults write com.apple.finder FXDefaultSearchScope -string SCcf
defaults write com.apple.finder NewWindowTarget -string PfLo
# パスは URL 形式。日本語フォルダ名はパーセントエンコードする
defaults write com.apple.finder NewWindowTargetPath -string \
  "file://${HOME}/Library/Mobile%20Documents/com~apple~CloudDocs/%E3%82%BF%E3%82%99%E3%82%A6%E3%83%B3%E3%83%AD%E3%83%BC%E3%83%88%E3%82%99/"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true      # USB メモリに .DS_Store を作らない

# --- Dock ---
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 48
defaults write com.apple.dock orientation -string left
defaults write com.apple.dock show-recents -bool false             # 最近使ったアプリを出さない

# --- スクリーンショット ---
mkdir -p "$ICLOUD_DOWNLOADS"
defaults write com.apple.screencapture location -string "$ICLOUD_DOWNLOADS"

# 設定を反映するため関連プロセスを再起動する
for app in Finder Dock SystemUIServer; do
  killall "$app" >/dev/null 2>&1 || true
done
echo "    キーリピート・ダークモード・入力の設定は、ログアウトして入り直すと確実に反映されます"
