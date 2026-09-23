# macOS の設定（macos/defaults.sh）

`defaults write` は、システム設定の画面で変えられる値をコマンドで書き込む仕組み。
`macos/defaults.sh` は 2026-09-23 時点のこの Mac の値を書き出し、実機で試して採用した設定を加えたもの。
新しい Mac で実行すると同じ状態になる。管理者権限が必要なセキュリティ設定は `macos/security.sh` に分けている（下記）。

```bash
./install.sh macos          # この項目だけ実行
```

キーリピート、ダークモード、入力の設定は、ログアウトして入り直すと確実に反映される。

## 設定一覧

### キーボード・入力

| 設定 | 値 | 意味 | システム設定での場所 |
| --- | --- | --- | --- |
| `-g InitialKeyRepeat` | `15` | キーを押し続けてからリピートが始まるまでの時間。15 は画面で選べる最短（約 225ms） | キーボード > リピート入力認識までの時間 |
| `-g KeyRepeat` | `2` | リピートの速さ。2 は画面で選べる最速（約 30ms 間隔） | キーボード > キーのリピート速度 |
| `-g NSAutomaticCapitalizationEnabled` | `false` | 文頭の自動大文字化をしない | キーボード > 入力ソース > 編集 > 文頭を自動的に大文字にする |
| `-g NSAutomaticPeriodSubstitutionEnabled` | `false` | スペース 2 回でピリオドにしない | キーボード > 入力ソース > 編集 > スペースバーを 2 回押してピリオドを入力 |
| `-g NSAutomaticQuoteSubstitutionEnabled` | `false` | `"` を “ ” に自動変換しない。コードや設定を書くときに便利 | キーボード > 入力ソース > 編集 > スマート引用符とスマートダッシュを使用 |
| `-g NSAutomaticDashSubstitutionEnabled` | `false` | `--` を — に自動変換しない | 同上 |
| `-g NSAutomaticSpellingCorrectionEnabled` | `false` | 英単語のスペルを自動で直さない | キーボード > 入力ソース > 編集 > スペルを自動で修正 |
| `-g ApplePressAndHoldEnabled` | `false` | キーを押し続けたとき、アクセント記号の候補ではなく同じ文字を連続入力する。vim の移動などで便利。アプリを起動し直すと反映 | 画面設定なし |

旧 dotfiles ではキーリピートを 0 にしていた。0 は画面では選べない値で、
速すぎて誤入力が増えるため採用していない。

### 外観

| 設定 | 値 | 意味 | システム設定での場所 |
| --- | --- | --- | --- |
| `-g AppleInterfaceStyle` | `Dark` | ダークモード | 外観 > 外観モード |

### Finder

| 設定 | 値 | 意味 | 画面での場所 |
| --- | --- | --- | --- |
| `_FXShowPosixPathInTitle` | `true` | ウインドウのタイトルにフルパスを表示 | 画面設定なし |
| `FXPreferredViewStyle` | `Nlsv` | 既定の表示をリスト表示にする（`icnv` アイコン、`clmv` カラム、`glyv` ギャラリー） | 表示メニュー |
| `FXDefaultSearchScope` | `SCcf` | 検索の既定範囲を「現在のフォルダ」にする（既定は `SCev` の Mac 全体） | Finder 設定 > 詳細 > 検索実行時 |
| `NewWindowTarget` / `NewWindowTargetPath` | `PfLo` / iCloud の「ダウンロード」 | 新規ウインドウで開く場所。`PfLo` は「その他の場所」を意味し、実際の場所は `NewWindowTargetPath` で指定する | Finder 設定 > 一般 > 新規 Finder ウインドウで次を表示 |
| `AppleLanguages` | `(en)` | **Finder だけ**英語表示にする。フォルダ名が Documents・Downloads・Applications などになり、Finder のメニューも英語になる。システムやほかのアプリは日本語のまま。iCloud Drive の「ダウンロード」は実際の名前が日本語なので変わらない | 言語と地域 > アプリケーション |
| `-g AppleShowAllExtensions` | `true` | すべての拡張子を表示 | Finder 設定 > 詳細 > すべてのファイル名拡張子を表示 |
| `ShowPathbar` | `true` | 下部に、今いるフォルダの場所（パスバー）を表示 | 表示メニュー > パスバーを表示 |
| `ShowStatusBar` | `true` | 下部に、項目数と空き容量（状態バー）を表示 | 表示メニュー > ステータスバーを表示 |
| `FXEnableExtensionChangeWarning` | `false` | 拡張子を書き換えたときの確認を出さない | Finder 設定 > 詳細 > 拡張子を変更する前に警告を表示 |
| `com.apple.desktopservices DSDontWriteNetworkStores` | `true` | ネットワークドライブに `.DS_Store` を作らない | 画面設定なし |
| `com.apple.desktopservices DSDontWriteUSBStores` | `true` | USB メモリに `.DS_Store` を作らない | 画面設定なし |

### Dock

| 設定 | 値 | 意味 | システム設定での場所 |
| --- | --- | --- | --- |
| `autohide` | `true` | Dock を自動的に隠す | デスクトップと Dock > Dock を自動的に表示/非表示 |
| `tilesize` | `48` | アイコンの大きさ（ピクセル） | デスクトップと Dock > サイズ |
| `orientation` | `left` | 画面の左端に表示 | デスクトップと Dock > 画面上の位置 |
| `show-recents` | `false` | 固定していない、最近使ったアプリを Dock に出さない | デスクトップと Dock > 提案されたアプリケーションと最近使用したアプリケーションを Dock に表示 |

### スクリーンショット

| 設定 | 値 | 意味 | 画面での場所 |
| --- | --- | --- | --- |
| `com.apple.screencapture location` | iCloud Drive の「ダウンロード」 | 保存先 | ⌘⇧5 > オプション > 保存先 |

## 元に戻す

`defaults delete` で macOS の既定値に戻る。

```bash
defaults delete -g InitialKeyRepeat
defaults delete -g KeyRepeat
defaults delete -g NSAutomaticCapitalizationEnabled
defaults delete -g NSAutomaticPeriodSubstitutionEnabled
defaults delete -g AppleInterfaceStyle              # ライトモードに戻る
defaults delete com.apple.finder _FXShowPosixPathInTitle
defaults delete com.apple.finder FXPreferredViewStyle
defaults delete com.apple.finder FXDefaultSearchScope
defaults delete com.apple.finder NewWindowTarget
defaults delete com.apple.finder NewWindowTargetPath
defaults delete com.apple.desktopservices DSDontWriteNetworkStores
defaults delete com.apple.dock autohide
defaults delete com.apple.dock tilesize
defaults delete com.apple.dock orientation
defaults delete com.apple.screencapture location   # デスクトップに戻る
defaults delete -g NSAutomaticQuoteSubstitutionEnabled
defaults delete -g NSAutomaticDashSubstitutionEnabled
defaults delete -g NSAutomaticSpellingCorrectionEnabled
defaults delete -g ApplePressAndHoldEnabled
defaults delete com.apple.finder AppleLanguages         # Finder がシステムの言語（日本語）に戻る
defaults delete -g AppleShowAllExtensions
defaults delete com.apple.finder ShowPathbar
defaults delete com.apple.finder ShowStatusBar
defaults delete com.apple.finder FXEnableExtensionChangeWarning
defaults delete com.apple.desktopservices DSDontWriteUSBStores
defaults delete com.apple.dock show-recents
killall Finder Dock SystemUIServer
```

## 今の値を調べる

```bash
defaults read -g KeyRepeat
defaults read com.apple.dock orientation
```

設定画面で何かを変えたときにどのキーが変わったかは、前後の差分で調べられる。

```bash
defaults read > before.txt
# 設定画面で変更する
defaults read > after.txt
diff before.txt after.txt
```

## 試して見送った設定（2026-09-23）

候補として検討し、今回は採用しなかったもの。使いたくなったら `macos/defaults.sh` に加える。

| 設定 | 意味 |
| --- | --- |
| `com.apple.dock autohide-delay -float 0` と `autohide-time-modifier` | Dock が出るまでの待ち時間をなくし、出入りを速くする（旧 dotfiles にあった） |
| `com.apple.dock mru-spaces -bool false` | よく使う順に操作スペースの順番が入れ替わらないようにする |
| `com.apple.finder _FXSortFoldersFirst -bool true` | 名前順でフォルダを先頭に並べる |
| `com.apple.screencapture disable-shadow -bool true` | ウインドウのスクリーンショットの影をなくす |

## セキュリティ設定（macos/security.sh）

管理者権限が必要なので、`defaults.sh` とは分けている。実行すると途中でパスワードを聞かれる。
すでに設定済みの項目は何もしないので、何度実行してもよい。

```bash
./install.sh security
```

| 設定 | 意味 | システム設定での場所 |
| --- | --- | --- |
| ファイアウォール | 外から Mac への接続を、許可したアプリ以外は受け付けない。公衆 Wi-Fi で特に重要 | ネットワーク > ファイアウォール |
| ステルスモード | 外からの問い合わせ（ping など）に応答せず、ネットワーク上で見つかりにくくする | ネットワーク > ファイアウォール > オプション |
| Touch ID で sudo | 管理者パスワードの代わりに指紋で認証できる。`/etc/pam.d/sudo_local` に書くので、macOS のアップデートで消えない | 画面設定なし |

Touch ID で sudo は、macOS 付属のひな形 `/etc/pam.d/sudo_local.template` の `pam_tid.so` の行を有効にして作る。
`/etc/pam.d/sudo_local` が別の内容で既にある場合は、上書きせずに警告だけ出す。

ファイアウォールを有効にすると、サーバーとして動くアプリ（Ollama、Docker、LM Studio など）の初回起動時に「接続を許可しますか」と聞かれることがある。自分で使うアプリなら許可する。

### 元に戻す

```bash
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate off
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode off
sudo rm /etc/pam.d/sudo_local
```

## 設定ではなく手作業で確認すること

- **FileVault**（ディスクの暗号化）：システム設定 > プライバシーとセキュリティ。`fdesetup status` で確認。`./install.sh check` でも確認する
- **画面ロック**：システム設定 > ロック画面。画面が消えたらすぐパスワードを求める設定にする
- **バックアップ**：Time Machine は使わない（2026-09-23 決定）。コードは GitHub、設定はこの dotfiles にある
