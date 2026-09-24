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
| `font-family = "BlexMono Nerd Font Mono"` と `font-family = "Hiragino Sans"` | 英数字は BlexMono（アイコン記号入り）、日本語はヒラギノ角ゴで表示する。1 行に 1 つずつ書くと上から順に使われる。以前はカンマでつないで 1 行に書いていたため、1 つの長いフォント名として読まれ、ヒラギノが効いていなかった（2026-09-23 に修正）。BlexMono は Brewfile の `font-blex-mono-nerd-font` で入る |
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

### プロファイル（US / JIS）

キーボードの配列ごとに 2 つのプロファイルを持つ。

| プロファイル | 使うキーボード | `keyboard_type_v2` | 英数・かなの切り替え |
| --- | --- | --- | --- |
| `US`（既定） | 外付けの US キーボード | `ansi` | caps_lock |
| `JIS` | MacBook 内蔵の JIS キーボード | `jis` | 英数キー・かなキー |

分けている理由は `keyboard_type_v2`（仮想キーボードを ANSI と JIS のどちらとして扱うか）にある。
これは**プロファイル単位の設定**で、キーボードごとには変えられない。
プロファイルの中でキーボードごとに変えられるのは、`simple_modifications`・`fn_function_keys`・
`ignore`・`treat_as_built_in_keyboard` などに限られる。
種別が合っていないと、JIS キーボードで `@` `[` `]` `_` などが別の文字になる。

### 切り替え方

`home/zshrc` の `kbd` 関数で切り替える。Karabiner 自体に、
つないだキーボードを見て自動で切り替える機能はない。

| コマンド | 動作 |
| --- | --- |
| `kbd` | 今のプロファイル名を表示する |
| `kbd us` | `US` に切り替える |
| `kbd jis` | `JIS` に切り替える |

切り替えると Karabiner が `karabiner.json` を書き戻すため、`JIS` を選んでいる間は
`selected` の行だけ git の差分に出る。これは想定どおりなのでコミットしない。
リポジトリには `US` を選んだ状態を入れてある。

つないでいるキーボードの `vendor_id` / `product_id` は、次のコマンドで調べられる。

```sh
"/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli" --list-connected-devices
```

### 設定内容

| 種類 | 内容 | 対象 | 意味 |
| --- | --- | --- | --- |
| 複雑な置き換え | caps_lock → 英数・かなのトグル | `US` | caps_lock 1 つで日本語入力と英語入力を行き来する。US キーボードには英数・かなキーがないため |
| 複雑な置き換え | 英数・かなキーをトグル式に | `JIS` | 日本語入力中にかなキーで英数へ、英数入力中に英数キーでかなへ切り替える |
| 複雑な置き換え | caps_lock + h/j/k/l → ←/↓/↑/→ | 両方 | Vim と同じキーで、どのアプリでも矢印キー操作ができる。caps_lock は両配列で同じ位置にある |

`assets/complex_modifications/` には、ネットから取り込んだルールの元ファイルが入っている。
有効になっているのは `karabiner.json` に書かれたルールだけ。

### 気づいた点

- 以前は、使われていない「Default profile (copy)」というプロファイルもあった。2026-09-23 の見直しで削除した
- 以前は、単純な置き換えでかなキーを右 Shift にしていた。複雑な置き換え（かな ↔ 英数のトグル）と
  対象が重なっていたため、2026-09-24 の US 配列への移行にあわせて削除した
- `US` で caps_lock は、英数・かなのトグルと hjkl の修飾キーを兼ねている。
  意図どおり動かないときは、Karabiner-EventViewer でキーを押して確認する
