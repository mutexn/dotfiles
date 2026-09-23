# macOS の設定（macos/defaults.sh）

`defaults write` は、システム設定の画面で変えられる値をコマンドで書き込む仕組み。
`macos/defaults.sh` は 2026-09-23 時点のこの Mac の値を書き出したもので、
新しい Mac で実行すると同じ状態になる。

```bash
./install.sh macos          # この項目だけ実行
```

キーリピートとダークモードは、ログアウトして入り直すと確実に反映される。

## 設定一覧

### キーボード・入力

| 設定 | 値 | 意味 | システム設定での場所 |
| --- | --- | --- | --- |
| `-g InitialKeyRepeat` | `15` | キーを押し続けてからリピートが始まるまでの時間。15 は画面で選べる最短（約 225ms） | キーボード > リピート入力認識までの時間 |
| `-g KeyRepeat` | `2` | リピートの速さ。2 は画面で選べる最速（約 30ms 間隔） | キーボード > キーのリピート速度 |
| `-g NSAutomaticCapitalizationEnabled` | `false` | 文頭の自動大文字化をしない | キーボード > 入力ソース > 編集 > 文頭を自動的に大文字にする |
| `-g NSAutomaticPeriodSubstitutionEnabled` | `false` | スペース 2 回でピリオドにしない | キーボード > 入力ソース > 編集 > スペースバーを 2 回押してピリオドを入力 |

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
| `com.apple.desktopservices DSDontWriteNetworkStores` | `true` | ネットワークドライブに `.DS_Store` を作らない | 画面設定なし |

### Dock

| 設定 | 値 | 意味 | システム設定での場所 |
| --- | --- | --- | --- |
| `autohide` | `true` | Dock を自動的に隠す | デスクトップと Dock > Dock を自動的に表示/非表示 |
| `tilesize` | `48` | アイコンの大きさ（ピクセル） | デスクトップと Dock > サイズ |
| `orientation` | `left` | 画面の左端に表示 | デスクトップと Dock > 画面上の位置 |

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

## 検証中・候補の設定

実機で試してから採用する（[README](../README.md) の「実機で検証してから標準化」）。

| 設定 | 意味 | 状態 |
| --- | --- | --- |
| `com.apple.desktopservices DSDontWriteUSBStores -bool true` | USB メモリに `.DS_Store` を作らない | 未検証 |
| `com.apple.dock autohide-delay -float 0` | Dock が出るまでの待ち時間をなくす（旧 dotfiles にあった） | 未検証 |
| `com.apple.dock show-recents -bool false` | Dock に最近使ったアプリを出さない | 未検証 |
| `com.apple.finder ShowPathbar -bool true` | Finder 下部にパスバーを表示 | 未検証 |
| `-g AppleShowAllExtensions -bool true` | すべての拡張子を表示 | 未検証 |
| `-g NSAutomaticQuoteSubstitutionEnabled -bool false` | `"` を “ ” に自動変換しない。コードを書くときに便利 | 未検証 |

## 設定ではなく手作業で確認すること

以下はセキュリティのためコマンドで一括設定しない。新しい Mac では手で確認する。

- **FileVault**（ディスク暗号化）：システム設定 > プライバシーとセキュリティ。`fdesetup status` で確認
- **ファイアウォール**：システム設定 > ネットワーク > ファイアウォール
- **Touch ID で sudo**：`/etc/pam.d/sudo_local` を作る方式なら OS アップデートで消えない

```bash
sudo cp /etc/pam.d/sudo_local.template /etc/pam.d/sudo_local
sudo sed -i '' 's/^#auth/auth/' /etc/pam.d/sudo_local
```
