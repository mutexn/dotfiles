# ターミナルと入力の設定（Ghostty・Karabiner-Elements）

## ファイルの対応

| リポジトリ | 実機の場所 | 役割 |
| --- | --- | --- |
| `config/ghostty/config` | `~/Library/Application Support/com.mitchellh.ghostty/config` | ターミナル Ghostty の設定 |
| `config/karabiner/`（フォルダごと） | `~/.config/karabiner/` | キー配列を変える Karabiner-Elements の設定 |

## Ghostty（config/ghostty/config）

Ghostty は起動時にこのファイルを読む。変更後は ⌘⇧, で再読み込みできる。

| 設定 | 意味 |
| --- | --- |
| `theme = TokyoNight` | 配色テーマ。`ghostty +list-themes` で一覧を見られる |
| `font-family = "BlexMono Nerd Font Mono", "Hiragino Sans"` | 英数字は BlexMono（アイコン記号入り）、日本語はヒラギノ角ゴで表示する。BlexMono は Brewfile の `font-blex-mono-nerd-font` で入る |
| `window-padding-x / y = 10` | ウインドウの内側の余白（ピクセル） |
| `window-padding-balance = true` | 余白を上下左右で均等にする |
| `quick-terminal-position = top` | クイックターミナルを画面上部から出す |
| `quick-terminal-screen = main` | メインのディスプレイに出す |
| `quick-terminal-animation-duration = 0.2` | 出し入れのアニメーション時間（秒） |
| `quick-terminal-autohide = true` | 他のアプリをクリックしたら自動で隠す |
| `keybind = global:ctrl+@=toggle_quick_terminal` | どのアプリを使っていても ctrl+@ でクイックターミナルを出し入れする。`global:` を使うには、システム設定のアクセシビリティで Ghostty を許可する必要がある |
| `unfocused-split-opacity = 0.7` | 画面分割時、操作していない側を暗くする |
| `macos-titlebar-style = tabs` | タブをタイトルバーに統合する |
| `macos-titlebar-proxy-icon = hidden` | タイトルバーのフォルダアイコンを隠す |
| `desktop-notifications = true` | ターミナル内のプログラムから macOS の通知を出せるようにする |

## Karabiner-Elements（config/karabiner/）

Karabiner は設定画面で変更すると `karabiner.json` を**丸ごと書き直す**。
ファイル単体をリンクすると、書き直しでリンクが普通のファイルに置き換わってしまう。
そのため `install.sh` は**フォルダごと**リンクする。
`automatic_backups/` は Karabiner が自動で作るバックアップなので、リポジトリには入れない。

### 設定内容

| 種類 | 内容 | 意味 |
| --- | --- | --- |
| 単純な置き換え | かなキー → 右 Shift | かなキーを Shift として使う |
| 複雑な置き換え | 左 ctrl + h/j/k/l → ←/↓/↑/→ | Vim と同じキーで、どのアプリでも矢印キー操作ができる |
| 複雑な置き換え | 英数・かなキーをトグル式に | 日本語入力中にかなキーで英数へ、英数入力中に英数キーでかなへ切り替える |
| キーボード種別 | JIS | 仮想キーボードを JIS 配列として扱う |

`assets/complex_modifications/` には、ネットから取り込んだルールの元ファイルが入っている。
有効になっているのは `karabiner.json` に書かれたルールだけ。

### 気づいた点

- 以前は、使われていない「Default profile (copy)」というプロファイルもあった。2026-09-23 の見直しで削除した
- 単純な置き換え（かな → 右 Shift）と複雑な置き換え（かな ↔ 英数のトグル）の両方がかなキーを対象にしている。
  実際にどちらが効いているかは、Karabiner-EventViewer でかなキーを押して確認できる。
  片方が不要なら見直しで削除する
