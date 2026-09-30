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
| ブラウザ | Chrome | | **既定に変更（2026-09-24）** | 下記「ブラウザの選定」 |
| | Arc | 開発元が Dia に移行し、Arc は保守のみ | **削除済み** | Dia に移行 |
| | Dia | Arc の後継 | **保留** | 2026-09-24 に既定を Chrome へ。畳むかは下記「ブラウザの選定」 |
| | Firefox | 表示確認用 | 残す | |
| エディタ / AI IDE | VS Code / Cursor / Antigravity | 3 つ併存 | 残す | |
| AI | ChatGPT Classic | 旧版アプリの残りの可能性 | 残す | |
| ローカル LLM | ollama / LM Studio | | 残す | ollama はほとんど使わないため、サーバーは常駐させず必要なときに `ollama serve` で起動する |
| | Jan | 3 つ目のローカル LLM アプリ | **削除済み** | 不要のため 2026-09-23 に削除。付属のコマンド `~/.local/bin/jan` もゴミ箱へ。データ（`~/Library/Application Support/Jan`）は残している |
| パスワード管理 | 1Password / Bitwarden | 2 つ併存 | 残す | |
| スクリーンショット | Gyazo（本体・Menu・Video）/ Shottr | macOS 標準（⌘⇧5）で足りるか | 両方残す | Gyazo は URL で共有、Shottr は撮影・注釈・文字認識。2026-09-23 に Shottr を Brewfile に追加 |
| オフィス | LibreOffice | 他のオフィスソフトと併存 | **削除済み** | |
| デザイン | Adobe XD | Adobe が開発を終了 | 残す | |
| WordPress 開発 | Local / DevKinsta | 同じ用途が 2 つ | 残す | |
| VPN | OpenVPN Connect（アプリ） | | 残す | |
| | openvpn（コマンド） | アプリと重複 | **削除済み** | 本体ファイルが root 所有だったため、管理者権限で削除 |
| git の画面操作 | lazygit / gitui / tig | 3 つ併存 | 残す | |
| ファイラー | nnn / ranger | 2 つ併存 | 残す | |
| Python | python@3.13（brew） | uv や mise で管理できる | **削除済み** | 依存しているものがないことを確認して 2026-09-23 に削除。Python は uv で管理する（[python.md](python.md)） |
| その他 | flux（brew） | InfluxDB 用の言語。f.lux と間違えて入れた可能性 | **削除済み** | |
| 旧ソフト | FileMaker Pro 18 Advanced | | **削除済み** | ゴミ箱へ移動 |
| | Canon Utilities | | 残す | |
| 設定 | Karabiner の「Default profile (copy)」 | 使われていないプロファイル | **削除済み** | `config/karabiner/karabiner.json` から削除し、実機にも反映済み |
| 設定 | `home/vimrc` | 旧 dotfiles の vim 設定。使われていない | **削除済み** | リポジトリから削除 |

### スクリーンショットのアプリ（2026-09-23 決定）

Gyazo と Shottr を両方使う。Gyazo は撮ってすぐ URL で共有するため、Shottr は撮影・注釈・文字認識のため。
検討のときに ShareX の名前が挙がったが、Windows 専用で Mac では使えない。比較した候補は次のとおり。

| アプリ | 特徴 | 価格 | Homebrew |
| --- | --- | --- | --- |
| CleanShot X | 撮影・注釈・録画・クラウド共有リンクまで一通りそろう。ShareX に最も近い | 有料（買い切り、クラウドはサブスク） | `cask "cleanshot"` |
| Shottr | 軽量。注釈・OCR・スクロール撮影 | 基本無料 | `cask "shottr"` |
| macOS 標準（⌘⇧5） | 撮影と画面収録。共有リンクは作れない | 無料 | 不要 |

Shottr は初回起動時に、システム設定 > プライバシーとセキュリティ > 画面収録 で許可する。

### ブラウザの選定（2026-09-24 決定）

既定のブラウザを Dia から Chrome に変更し、Claude の Chrome 拡張を使う。Dia は消さずに保留する。

Sidekick → Arc → Dia と乗り換えてきたが、Dia で実際に使っていたのはチャットとピンだけだった。
タブグループ・プロファイル・タブ検索・垂直タブは使っていない。この用途なら Chrome と拡張で足りる。

#### 比較した候補

| 候補 | エンジン | 判断 | 理由 |
| --- | --- | --- | --- |
| Chrome | Chromium | **採用** | Claude 拡張が公式に対応するのは Chrome。`claude --chrome` と chrome-devtools-mcp も Chrome 前提 |
| Dia | Chromium | 保留 | 使っているのがチャットとピンだけ。Claude 拡張を入れてもサイドパネルしか動かない（下記） |
| Orion（Kagi） | **WebKit** | 見送り。逃げ道として記録 | Chrome 比で RAM 約 30% 減。ただし WebExtensions API の対応が約 7 割で、拡張は実験扱い |
| Safari | WebKit | 見送り | Claude の Safari 拡張は要望が「予定なし」で閉じられている |
| ChatGPT Atlas / Perplexity Comet | Chromium | 見送り | Dia を別の AI ブラウザに置き換えるだけで、Claude 中心の構成から外れる |
| Google Disco | Chromium | 見送り | Google Labs の実験。目玉の GenTab は大量のタブを横断する用途向けで噛み合わない |
| Firefox | Gecko | 残す | 表示確認用。用途が違うので比較対象外 |

#### 「Chrome は重い」について

過去に Chrome を離れた理由はこれだが、原因はエンジンではなかった。
Sidekick・Arc・Dia はすべて Chromium で、Chrome と同じ Blink を使っている。軽く感じた正体は次の 3 つ。

1. **タブ抑制**。Sidekick の AI タブサスペンダー、Arc の自動アーカイブにあたる機能を、Chrome は Memory Saver として標準搭載している（Chrome 108 以降。138 でレンダラのメモリを 15〜20% 削減、140 で ML ベースの予測破棄）。当時の Chrome には無かった
2. **UI が空いて見えること**
3. **入れたてのプロファイル**。乗り換え直後は拡張も履歴もタブもない

Arc と Chrome の実測ベンチは結論が割れており、Arc が構造的に軽い証拠はない。
そもそもピンしか使わずタブを溜めない運用では差が出ない。差がつくのは 30〜50 タブを開く使い方で、
この Mac は M6 / 32GB なので影響も小さい。エンジンとして本当に軽いのは WebKit 勢（Safari・Orion）だけ。

#### Dia に Claude 拡張を入れて両取りする案は成立しない

拡張自体はインストールでき、サイドパネルのチャットは動く。ただし Claude Code とは繋がらない。

- `--chrome` はブラウザ検出をハードコードした一覧で行っており、Dia が入っていない
- ネイティブメッセージングホストの設定ファイルが Dia のディレクトリに書かれない
- Dia は `chrome.tabGroups` API を完全実装しておらず、`Failed to query tabs: Grouping is not supported by tabs in this window` で失敗する

anthropics/claude-code に Issue が 3 本（#19268、#34830、#36410）あるが未対応。

#### Claude 拡張が Dia のチャットの代わりになるか

なる。Skills・プラグイン・コネクタは Claude 本体のものがサイドパネルでもそのまま動き、
タブ横断も Claude のタブグループにタブをドラッグすれば扱える。リモート MCP コネクタにも対応している。

加えて Dia に無いものとして、拡張自体が `claude-in-chrome` という MCP サーバーとして動き、
`claude --chrome` から Claude Code がブラウザを操作できる。ログイン状態を共有するため、
API やコネクタなしで Gmail・Notion・Google Docs を扱える。
コンソール・DOM・ネットワークの読み取り、ファイルアップロード（合計 10MB まで）、GIF 録画、
スケジュール実行（日次・週次・月次・年次）、1Password 連携もある。

要件は拡張 v1.0.36 以降、Pro / Max / Team / Enterprise の直接契約、`/login` での認証。
**API キーや `claude setup-token` の長期トークンでは連携が無効になる。**

Memory だけは同義ではない。Dia の Memory は閲覧文脈を蓄積して検索するもので、
Claude 側は会話・ユーザー文脈の記憶にあたる。

#### Dia を保留にした理由

Dia に残る利点が 2 つある。これを試してから畳むか決める。

- **モデルを選べる**。Dia は GPT（OpenAI / Azure）・Claude（Anthropic / Vertex / AWS）・Gemini（Vertex）を使い分ける。Chrome と拡張は Claude 一択で、Claude の有料プランに紐づく。プランを落とすとブラウザの AI が消える
- **プライバシー設計**。会話・履歴・ブックマーク・ファイルを既定で端末上に暗号化保存し、同期は E2E

判断のために Dia の Skills と Memory を実際に使ってみる。刺されば残し、刺さらなければ Brewfile から外す。
Dia Pro（月 20 ドル）に課金している場合は、Claude との二重払いになるのでそこも含めて判断する。

#### モバイル

iPhone の既定は Safari のままにし、Chrome は同期のために併用する。

- iOS のブラウザは全て WebKit を使う規約のため、iPhone の Chrome は「Chrome の UI と Google 同期をかぶせた Safari」。性能上の利点がない
- OS 統合（Handoff、Keychain、Apple Pay）とコンテンツブロッカーは Safari が上。Claude 拡張はモバイル非対応
- 既定にしなくても、Chrome アプリを入れておけば Mac の Chrome の履歴と開いているタブは読める
- スマホソフトウェア競争促進法（2025-12-18 全面施行）で代替エンジンが解禁され、Blink 版 Chrome は 2026 年中頃から後半に日本で登場する見込み。出たら既定を見直す

#### 手作業が必要なこと

既定ブラウザは LaunchServices の管理下にあり、`defaults write` では設定できないため手で行う。

1. システム設定 > デスクトップと Dock > デフォルトの Web ブラウザ を Chrome にする
2. Chrome に Claude 拡張を入れる（`claude --chrome` の連携には v1.0.36 以降が必要）
3. Chrome を下表のとおり設定する
4. Dia でピンしているサイトを Chrome でもピンし直す

| 場所 | 設定 | 理由 |
| --- | --- | --- |
| `chrome://settings/performance` | メモリセーバーを有効にし、ピン留めしたサイトを「常にアクティブにするサイト」に登録 | 解放されると、ピンをクリックするたびに読み込み直しになる |
| `chrome://settings/system` | 「Google Chrome を閉じた際にバックグラウンドアプリの処理を続行する」を OFF | 閉じたあとも常駐させない |
| `chrome://settings/onStartup` | 「前回開いていたタブを開く」 | ピンを確実に復元する |

拡張機能は最小限にし、各拡張のサイトアクセスは「すべてのサイト」ではなく「クリックした場合のみ」にする。
軽さと、ページを読む拡張のプロンプトインジェクション対策の両方に効く。

Chrome のピンは Arc や Dia と違い、リンクを踏んで移動しても元の URL に戻らない。挙動の差はここだけ。

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

**注意：管理者パスワードが必要な cask は、必ず自分のターミナルで実行する。**
2026-09-23 に docker-desktop を Claude Code から `--adopt` したところ、パスワードを入力できずに失敗し、
Homebrew の後始末で既存の Docker.app が削除された。データ（`~/Library/Containers/com.docker.docker`）は無事だった。
パスワードが必要かは、`brew info --cask <名前>` で pkg を使うか、特権ヘルパーを入れるかで見分けられる。

### 管理下への移行の結果（2026-09-23）

| アプリ | 結果 |
| --- | --- |
| Dia | 移行済み |
| Spotify | 移行済み |
| Docker Desktop | 失敗してアプリ本体が削除された。データは無事で、手動で入れ直して管理下に入った |
| Google Drive | 初回は失敗。手動で実行し移行済み |

### 手動で行った作業（管理者パスワードが必要なもの）

```bash
# Docker Desktop を入れ直す（コンテナやイメージのデータはそのまま使われる）
brew install --cask docker-desktop

# Google Drive を Homebrew の管理下に移す
brew install --cask --adopt google-drive

# openvpn の残りを消す（root 所有のファイルが残っている）
sudo rm -rf /opt/homebrew/Cellar/openvpn/2.7.5/sbin
brew uninstall --force openvpn
```

## 問題なく使っているもの

| カテゴリ | アプリ |
| --- | --- |
| AI | Claude、ChatGPT、Typeless（音声入力） |
| 入力・操作 | Raycast、AltTab、Karabiner-Elements、KeyboardCleanTool、Google 日本語入力 |
| 仕事 | Slack、Zoom、Notion、Obsidian、Anki、Figma、Adobe Creative Cloud |
| 開発 | gcloud CLI、Cyberduck、Chrome Remote Desktop（自動起動は停止）、gh、mise、direnv、uv、neovim、tmux、libpq、poppler、Contentful CLI |
| ユーティリティ | AppCleaner、1Password（本体・CLI）、AnkerWork |

## 見直しの記録

| 日付 | 内容 |
| --- | --- |
| 2026-09-23 | 一覧を作成 |
| 2026-09-23 | 見直し結果を Brewfile に反映。Arc・LibreOffice・openvpn・python@3.13・flux・FileMaker Pro 18 を削除対象に。Dia・Docker Desktop・Spotify・Google Drive と App Store アプリ 10 個を Brewfile に追加。Gyazo は代替を検討中 |
| 2026-09-23 | Shottr の試用を開始 |
| 2026-09-23 | Python を uv に集約。python@3.13 を削除 |
| 2026-09-23 | Arc・LibreOffice・flux・FileMaker Pro 18 を削除。Dia・Spotify を Homebrew 管理下へ。Docker Desktop の移行に失敗しアプリが削除された（データは無事） |
| 2026-09-23 | Docker Desktop を入れ直し、Google Drive を管理下へ移し、openvpn を削除。Brewfile と実機が一致（試用中の Shottr を除く） |
| 2026-09-23 | Shottr を採用し Brewfile に追加。Gyazo も残す |
| 2026-09-23 | `brew upgrade` を実施。Jan を削除 |
| 2026-09-23 | Chrome リモートデスクトップはアプリを残し、ログイン時の自動起動だけを止めた（普段は使っておらず、遠隔操作の入口を常駐させないため）。Ollama の自動起動設定（`~/Library/LaunchAgents/homebrew.mxcl.ollama.plist`）を退避し、ログイン時に常駐しないようにした |
| 2026-09-23 | 別の Mac でのセットアップ中に、Keynote・Pages・Numbers の App Store の ID が変わっていて入らないことが分かった。Brewfile を新しい ID（iPhone 版と同じ ID）に更新 |
| 2026-09-24 | 既定のブラウザを Dia から Chrome に変更。Claude 拡張と Claude Code の連携を使うため。Dia は畳まず保留（「ブラウザの選定」） |
| 2026-09-30 | Contentful CLI を Homebrew の `contentful-cli` で追加。あわせて実機にあるのに Brewfile に載っていなかった 1Password（本体）と AnkerWork を宣言した。herdr は入れたばかりのため試用中 |

### Chrome リモートデスクトップの自動起動を戻すとき

止め方：`./install.sh security` が、ログイン時に起動する `org.chromium.chromoting`（`/Library/LaunchAgents`）を `launchctl disable` で無効にする。
もう 1 つの `org.chromium.chromoting.broker`（`/Library/LaunchDaemons`）は、呼ばれたときだけ起動する作りなので、そのままでも常駐しない。

使うときは、自動起動を有効に戻してから、ブラウザで remotedesktop.google.com/access を開いて遠隔操作を有効にする。

```bash
launchctl enable gui/$(id -u)/org.chromium.chromoting
```

新しい Mac では `./install.sh security` が自動で止めるため、手作業は不要。

