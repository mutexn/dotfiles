# Brewfile — Homebrew で入れるコマンドとアプリの一覧。詳細は docs/brew.md
# 2026-09-23 時点の実機の構成をそのまま書き出したもの。
# 見直し中の項目は docs/apps.md で採否を決めてから、この一覧に反映する。

# ============================================================
# コマンドラインツール（formula）
# ============================================================

# --- 開発の基盤 ---
brew "mise"           # Node などのランタイム管理（docs/mise.md）
brew "direnv"         # ディレクトリごとに .envrc の環境変数を読み込む
brew "uv"             # Python のパッケージ・プロジェクト管理
brew "python@3.13"    # 見直し候補: uv / mise に寄せるか検討
brew "gh"             # GitHub CLI（git の認証ヘルパーにも使用）
brew "libpq"          # PostgreSQL クライアント（psql）

# --- git の画面操作（TUI）---
brew "lazygit"        # 見直し候補: 3 つ併存
brew "gitui"          # 見直し候補
brew "tig"            # 見直し候補

# --- ファイル操作・ターミナル ---
brew "neovim"         # エディタ
brew "tmux"           # ターミナル多重化
brew "nnn"            # 見直し候補: ファイラーが 2 つ併存
brew "ranger"         # 見直し候補

# --- AI / その他 ---
brew "ollama"         # ローカル LLM の実行環境
brew "poppler"        # PDF ツール（pdftotext など）
brew "bitwarden-cli"  # 見直し候補: 1Password と併存
brew "openvpn"        # 見直し候補: OpenVPN Connect アプリと重複
brew "flux"           # 見直し候補: InfluxDB 用の言語。f.lux（画面色温度）とは別物
brew "mas"            # App Store アプリをコマンドで入れる

# ============================================================
# アプリ（cask）
# ============================================================

# --- ターミナル ---
cask "ghostty"        # メイン候補
cask "cmux"           # AI エージェント向けターミナル
cask "warp"           # 見直し候補

# --- ブラウザ ---
cask "google-chrome"
cask "arc"            # 見直し候補: 開発縮小
cask "firefox"        # 見直し候補

# --- エディタ / AI IDE ---
cask "visual-studio-code"
cask "cursor"
cask "antigravity"    # 見直し候補

# --- AI ---
cask "claude"
cask "chatgpt"
cask "typeless"       # 音声入力
cask "lm-studio"      # 見直し候補: ローカル LLM アプリが複数
cask "jan"            # 見直し候補

# --- パスワード管理 ---
cask "1password-cli"
cask "bitwarden"      # 見直し候補: 1Password と併存

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
cask "libreoffice"    # 見直し候補

# --- 開発・インフラ ---
cask "gcloud-cli"
cask "cyberduck"      # FTP / S3 クライアント
cask "local"          # 見直し候補: WordPress ローカル環境。DevKinsta と重複
cask "openvpn-connect"
cask "chrome-remote-desktop-host"

# --- ユーティリティ ---
cask "appcleaner"     # アプリを関連ファイルごと削除
cask "gyazo"          # 見直し候補: 標準スクリーンショットで足りるか

# ============================================================
# App Store アプリ（mas）
# ============================================================
# mas コマンドの一覧取得がこの Mac で応答しなかったため未記入。
# 見直し後に `mas list` の ID をもとに追記する。例:
# mas "LINE", id: 539883307
