# アプリ一覧と見直し

2026-09-23 時点でこの Mac に入っているアプリとコマンドの一覧。
「判断」列を埋めたら Brewfile に反映し、不要なものはアンインストールする。

判断の書き方：**残す** / **削除** / **置換（→ 代わりのもの）**。理由も一言添える。

## 見直しが必要なもの（重複・古いもの）

| カテゴリ | アプリ | 論点 | 判断 | 理由 |
| --- | --- | --- | --- | --- |
| ターミナル | Ghostty | 設定済みでメインと思われる | | |
| | cmux | AI エージェント並行作業向け | | |
| | Warp | 3 つ目のターミナル | | |
| ブラウザ | Chrome | | | |
| | Arc | 開発元が Dia に移行し、Arc は保守のみ | | |
| | Dia | Arc の後継。Brewfile 未登録 | | |
| | Firefox | 表示確認用なら残す | | |
| エディタ / AI IDE | VS Code | | | |
| | Cursor | | | |
| | Antigravity | 3 つ目の AI IDE | | |
| AI | ChatGPT Classic | 旧版アプリの残りの可能性 | | |
| ローカル LLM | ollama / LM Studio / Jan | 3 つ併存 | | |
| パスワード管理 | 1Password / Bitwarden | どちらかに統一。Bitwarden を消すと bitwarden-cli と brew の node も不要になる | | |
| スクリーンショット | Gyazo（本体・Menu・Video） | macOS 標準（⌘⇧5）で足りるか | | |
| オフィス | LibreOffice | MS Office・iWork・Google ドキュメントと併存 | | |
| デザイン | Adobe XD | Adobe が開発を終了 | | |
| WordPress 開発 | Local / DevKinsta | 同じ用途が 2 つ | | |
| VPN | OpenVPN Connect（アプリ）/ openvpn（コマンド） | 同じ用途が 2 つ | | |
| git の画面操作 | lazygit / gitui / tig | 3 つ併存 | | |
| ファイラー | nnn / ranger | 2 つ併存 | | |
| Python | python@3.13（brew） | uv や mise で管理できる | | |
| その他 | flux（brew） | InfluxDB 用の言語。画面の色温度を変える f.lux と間違えて入れた可能性 | | |
| 旧ソフト | FileMaker Pro 18 Advanced | 現役で使っているか | | |
| | Canon Utilities | プリンタ・スキャナを使っているか | | |
| 設定 | Karabiner の「Default profile (copy)」 | 使われていないプロファイル | | |
| 設定 | `home/vimrc` | 旧 dotfiles の vim 設定。今の Mac では使われておらず、リンクもしていない | | |

## Homebrew 以外で入れているもの

Brewfile に入れるか、手動のままにするかを決める。

| アプリ | 今の入れ方 | 論点 | 判断 |
| --- | --- | --- | --- |
| Docker Desktop | 手動 | `cask "docker-desktop"` にできる | |
| Dia | 手動 | `cask "dia"` にできる | |
| Spotify | 手動 | `cask "spotify"` にできる | |
| Google Drive | 手動 | `cask "google-drive"` にできる | |
| Microsoft Word / Excel / PowerPoint | 手動 | `cask "microsoft-office"` か App Store | |
| LINE、Goodnotes、Kindle、Keynote、Pages、Numbers、iMovie | App Store と思われる | `mas` で Brewfile に入れる | |
| ovice | 手動 | | |
| e-Gov、e-Tax、JPKI、ELPKI | 公式サイト | Homebrew にないため手動のまま | 残す |
| Adobe Illustrator / Photoshop | Creative Cloud | Creative Cloud から入れる | 残す |

## 問題なく使っているもの

| カテゴリ | アプリ |
| --- | --- |
| AI | Claude、ChatGPT、Typeless（音声入力） |
| 入力・操作 | Raycast、AltTab、Karabiner-Elements、KeyboardCleanTool、Google 日本語入力 |
| 仕事 | Slack、Zoom、Notion、Obsidian、Anki、Figma、Adobe Creative Cloud |
| 開発 | gcloud CLI、Cyberduck、Chrome Remote Desktop、gh、mise、direnv、uv、neovim、tmux、libpq、poppler |
| ユーティリティ | AppCleaner、1Password CLI |

## 見直しの記録

判断を反映したら、ここに日付と内容を残す。

| 日付 | 内容 |
| --- | --- |
| 2026-09-23 | 一覧を作成 |
