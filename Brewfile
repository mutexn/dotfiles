# Brewfile — Homebrew で入れるコマンドとアプリの一覧。詳細は docs/brew.md
# 2026-09-23 に実機の構成を書き出し、アプリ見直しの結果を反映したもの。
# 採否の理由は docs/apps.md に記録している。

# ============================================================
# コマンドラインツール（formula）
# ============================================================

# --- 開発の基盤 ---
brew "mise"           # Node などのランタイム管理（docs/mise.md）
brew "direnv"         # ディレクトリごとに .envrc の環境変数を読み込む
brew "uv"             # Python の本体・仮想環境・パッケージ管理（docs/python.md）
brew "gh"             # GitHub CLI（git の認証ヘルパーにも使用）
brew "libpq"          # PostgreSQL クライアント（psql）

# --- git の画面操作（TUI）---
brew "lazygit"        # git の画面操作（TUI）
brew "gitui"          # git の画面操作（TUI）
brew "tig"            # git の履歴ビューア

# --- ファイル操作・ターミナル ---
brew "neovim"         # エディタ
brew "tmux"           # ターミナル多重化
brew "nnn"            # ファイラー
brew "ranger"         # ファイラー

# --- AI / その他 ---
brew "ollama"         # ローカル LLM の実行環境
brew "poppler"        # PDF ツール（pdftotext など）
brew "bitwarden-cli"  # Bitwarden の CLI
brew "mas"            # App Store アプリをコマンドで入れる

# ============================================================
# アプリ（cask）
# ============================================================

# --- ターミナル ---
cask "ghostty"        # メインのターミナル（config/ghostty）
cask "cmux"           # AI エージェント向けターミナル
cask "warp"

# --- ブラウザ ---
cask "google-chrome"
cask "thebrowsercompany-dia"  # Dia
cask "firefox"

# --- エディタ / AI IDE ---
cask "visual-studio-code"
cask "cursor"
cask "antigravity"

# --- AI ---
cask "claude"
cask "chatgpt"
cask "typeless"       # 音声入力
cask "lm-studio"      # ローカル LLM
cask "jan"            # ローカル LLM

# --- パスワード管理 ---
cask "1password-cli"
cask "bitwarden"

# --- 入力・操作 ---
cask "raycast"               # ランチャー
cask "alt-tab"               # Windows 風のウインドウ切り替え
cask "karabiner-elements"    # キー配列の変更（config/karabiner）
cask "keyboardcleantool"     # 掃除用にキー入力を一時無効化
cask "google-japanese-ime"
cask "font-blex-mono-nerd-font"  # Ghostty で使うフォント

# --- 仕事・コミュニケーション ---
cask "slack"
cask "zoom"
cask "notion"
cask "obsidian"
cask "anki"
cask "figma"
cask "adobe-creative-cloud"

# --- 開発・インフラ ---
cask "gcloud-cli"
cask "docker-desktop"
cask "cyberduck"      # FTP / S3 クライアント
cask "local"          # WordPress ローカル環境
cask "openvpn-connect"
cask "chrome-remote-desktop-host"

# --- ユーティリティ ---
cask "google-drive"
cask "spotify"
cask "appcleaner"     # アプリを関連ファイルごと削除
cask "gyazo"          # スクリーンショット共有。代替を検討中（docs/apps.md）

# ============================================================
# App Store アプリ（mas）
# ============================================================
# 事前に App Store アプリで Apple アカウントにサインインしておく必要がある

mas "Microsoft Word", id: 462054704
mas "Microsoft Excel", id: 462058435
mas "Microsoft PowerPoint", id: 462062816
mas "Keynote", id: 409183694
mas "Pages", id: 409201541
mas "Numbers", id: 409203825
mas "iMovie", id: 408981434
mas "LINE", id: 539883307
mas "Goodnotes", id: 1444383602
mas "Kindle", id: 302584613
