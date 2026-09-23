# アプリ一覧と見直し

2026-09-23 時点でこの Mac に入っているアプリとコマンドの一覧と、見直しの結果。
判断を Brewfile に反映し、不要なものはアンインストールする。

判断の書き方：**残す** / **削除** / **置換（→ 代わりのもの）** / **検討中**。

## 重複・古いものの見直し結果

| カテゴリ | アプリ | 論点 | 判断 | 理由・メモ |
| --- | --- | --- | --- | --- |
| ターミナル | Ghostty | 設定済みのメイン | 残す | |
| | cmux | AI エージェント並行作業向け | 残す | |
| | Warp | 3 つ目のターミナル | 残す | |
| ブラウザ | Chrome | | 残す | |
| | Arc | 開発元が Dia に移行し、Arc は保守のみ | **削除** | Dia に移行 |
| | Dia | Arc の後継 | 残す | Brewfile に追加 |
| | Firefox | 表示確認用 | 残す | |
| エディタ / AI IDE | VS Code / Cursor / Antigravity | 3 つ併存 | 残す | |
| AI | ChatGPT Classic | 旧版アプリの残りの可能性 | 残す | |
| ローカル LLM | ollama / LM Studio / Jan | 3 つ併存 | 残す | |
| パスワード管理 | 1Password / Bitwarden | 2 つ併存 | 残す | |
| スクリーンショット | Gyazo（本体・Menu・Video） | macOS 標準（⌘⇧5）で足りるか | **検証中** | ShareX は Windows 専用のため、Mac 向けの Shottr を 2026-09-23 から試用中。結果が出るまで Gyazo も残す |
| オフィス | LibreOffice | 他のオフィスソフトと併存 | **削除** | |
| デザイン | Adobe XD | Adobe が開発を終了 | 残す | |
| WordPress 開発 | Local / DevKinsta | 同じ用途が 2 つ | 残す | |
| VPN | OpenVPN Connect（アプリ） | | 残す | |
| | openvpn（コマンド） | アプリと重複 | **削除** | アプリで足りる |
| git の画面操作 | lazygit / gitui / tig | 3 つ併存 | 残す | |
| ファイラー | nnn / ranger | 2 つ併存 | 残す | |
| Python | python@3.13（brew） | uv や mise で管理できる | **削除** | 依存しているものがないことを確認済み。`python3` コマンドは mlx・ollama・ranger の依存で入る python@3.14 が引き続き提供する |
| その他 | flux（brew） | InfluxDB 用の言語。f.lux と間違えて入れた可能性 | **削除** | |
| 旧ソフト | FileMaker Pro 18 Advanced | | **削除** | Homebrew 管理外なので手動で削除 |
| | Canon Utilities | | 残す | |
| 設定 | Karabiner の「Default profile (copy)」 | 使われていないプロファイル | **削除** | `config/karabiner/karabiner.json` から削除済み。実機には `./install.sh link` 実行時に反映 |
| 設定 | `home/vimrc` | 旧 dotfiles の vim 設定。使われていない | **削除** | リポジトリから削除済み |

### Gyazo の代替候補（Mac 用）

ShareX は Windows 専用のため Mac では使えない。Mac で ShareX に近いことができるもの：

| アプリ | 特徴 | 価格 | Homebrew |
| --- | --- | --- | --- |
| CleanShot X | 撮影・注釈・録画・クラウド共有リンクまで一通りそろう。ShareX に最も近い | 有料（買い切り、クラウドはサブスク） | `cask "cleanshot"` |
| Shottr | 軽量。注釈・OCR・スクロール撮影 | 基本無料 | `cask "shottr"` |
| macOS 標準（⌘⇧5） | 撮影と画面収録。共有リンクは作れない | 無料 | 不要 |

Gyazo の「撮ってすぐ URL で共有」を重視するなら CleanShot X、撮影と注釈だけなら Shottr が向いている。
決まるまでは Gyazo を残す。

**Shottr の試用（2026-09-23 開始）**：`brew install --cask shottr` でインストール済み。Brewfile にはまだ入れていない。
初回起動時に、システム設定 > プライバシーとセキュリティ > 画面収録 で Shottr を許可する。
採用なら Brewfile に `cask "shottr"` を追加して Gyazo を削除し、不採用なら `brew uninstall --cask shottr` する。

## Homebrew 以外で入れていたもの

| アプリ | 今の入れ方 | 判断 | Brewfile での記述 |
| --- | --- | --- | --- |
| Docker Desktop | 手動 | Brewfile に入れる | `cask "docker-desktop"` |
| Dia | 手動 | Brewfile に入れる | `cask "thebrowsercompany-dia"` |
| Spotify | 手動 | Brewfile に入れる | `cask "spotify"` |
| Google Drive | 手動 | Brewfile に入れる | `cask "google-drive"` |
| Microsoft Word / Excel / PowerPoint | App Store | App Store 版で Brewfile に入れる | `mas`。今の入れ方に合わせた |
| LINE、Goodnotes、Kindle、Keynote、Pages、Numbers、iMovie | App Store | Brewfile に入れる | `mas` |
| ovice | 手動 | 残す（手動のまま） | なし |
| e-Gov、e-Tax、JPKI、ELPKI | 公式サイト | 残す（Homebrew にない） | なし |
| Adobe Illustrator / Photoshop | Creative Cloud | 残す（Creative Cloud から入れる） | なし |

手動で入れたアプリを Brewfile に加えた場合、この Mac では Homebrew がまだ「自分が入れたもの」と認識していない。
新しい Mac では問題ないが、この Mac で `brew bundle` を実行すると「既にアプリがある」というエラーになる。
その場合は、既存のアプリを Homebrew の管理下に移す。

```bash
brew install --cask --adopt docker-desktop thebrowsercompany-dia spotify google-drive
```

`--adopt` は、入っているアプリと同じバージョンなら置き換えずに管理下に移す。
バージョンが違う場合は失敗するので、そのアプリはいったん最新版に更新してから再実行する。

## 問題なく使っているもの

| カテゴリ | アプリ |
| --- | --- |
| AI | Claude、ChatGPT、Typeless（音声入力） |
| 入力・操作 | Raycast、AltTab、Karabiner-Elements、KeyboardCleanTool、Google 日本語入力 |
| 仕事 | Slack、Zoom、Notion、Obsidian、Anki、Figma、Adobe Creative Cloud |
| 開発 | gcloud CLI、Cyberduck、Chrome Remote Desktop、gh、mise、direnv、uv、neovim、tmux、libpq、poppler |
| ユーティリティ | AppCleaner、1Password CLI |

## 見直しの記録

| 日付 | 内容 |
| --- | --- |
| 2026-09-23 | 一覧を作成 |
| 2026-09-23 | 見直し結果を Brewfile に反映。Arc・LibreOffice・openvpn・python@3.13・flux・FileMaker Pro 18 を削除対象に。Dia・Docker Desktop・Spotify・Google Drive と App Store アプリ 10 個を Brewfile に追加。Gyazo は代替を検討中 |
| 2026-09-23 | Shottr の試用を開始 |
