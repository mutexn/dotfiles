# zsh の設定

zsh は macOS 標準のシェル。起動の種類に応じて、決まった順番で設定ファイルを読む。

## ファイルの対応

| リポジトリ | 実機の場所 | いつ読まれるか |
| --- | --- | --- |
| `home/zshenv` | `~/.zshenv` | **すべての** zsh 起動時（スクリプト実行も含む）。最初に読まれる |
| `home/zprofile` | `~/.config/zsh/.zprofile` | ログインシェル起動時（ターミナルアプリで新しいウインドウを開いたとき） |
| `home/zshrc` | `~/.config/zsh/.zshrc` | 対話シェル起動時（プロンプトが出るとき） |
| `config/starship.toml` | `~/.config/starship.toml` | `.zshrc` から起動する starship が読む。プロンプトの見た目 |
| なし | `~/.config/zsh/local.zsh` | `.zshrc` の最後に読まれる。**秘密情報とマシン固有の設定専用**。リポジトリに入れない |

ターミナルで新しいウインドウを開くと、次の順で読まれる。

```
~/.zshenv  →  ~/.config/zsh/.zprofile  →  ~/.config/zsh/.zshrc  →  ~/.config/zsh/local.zsh
```

`zsh script.sh` のようにスクリプトを実行したときは `.zshenv` だけが読まれる。
そのため `.zshenv` には重い処理や画面表示を書かない。

## 役割分担の考え方

- **`.zshenv`**：どんな場面でも必要な環境変数だけ
- **`.zprofile`**：ログイン時に 1 回だけ行う PATH の初期設定（Homebrew）
- **`.zshrc`**：対話で使う機能（プロンプト、エイリアス、補完、各ツールのフック）

## 各設定の意味

### home/zshenv

| 設定 | 意味 |
| --- | --- |
| `XDG_*` | 設定・データ・状態・キャッシュの置き場所（[xdg.md](xdg.md)） |
| `ZDOTDIR` | zsh の `.zprofile` と `.zshrc` を `~/.config/zsh/` から読む。これでホームに残る zsh のファイルは `~/.zshenv` だけになる |
| `LESSHISTFILE` などの `*_HISTORY` | less・node・psql の履歴を `~/.local/state/` に置く |
| `SHELL_SESSIONS_DISABLE=1` | macOS 標準のターミナル用のセッション保存（`~/.zsh_sessions`）を使わない |
| `typeset -U path PATH` | PATH の重複を自動で取り除く。`exec zsh` や tmux でシェルを入れ子に起動しても PATH が伸びない |
| `VOLTA_HOME` と `path+=(...)` | Volta を PATH の**末尾**に追加する。Volta は package.json の `volta` キーで Node を固定している旧プロジェクト用で、撤去予定（[mise.md](mise.md)） |

Volta を末尾に置く理由：以前は先頭に追加していた。そのため `exec zsh` でシェルを開き直すと、
Volta の pnpm が standalone 版より先に使われる不具合があった（2026-09-23 に修正）。

### home/zprofile

| 設定 | 意味 |
| --- | --- |
| `eval "$(/opt/homebrew/bin/brew shellenv)"` | Homebrew の場所（`/opt/homebrew/bin` など）を PATH に追加し、関連する環境変数を設定する。Apple Silicon の Mac では Homebrew が `/opt/homebrew` に入るため必須 |

### home/zshrc

上から順に読まれる。順番に意味がある。

| 設定 | 意味 |
| --- | --- |
| `PATH="$HOME/.local/bin:$PATH"` | 自分で入れたコマンド（Claude Code など）の置き場所を PATH に追加 |
| `starship init zsh` | プロンプトを starship にする。starship が入っていないときは zsh 標準のプロンプトのまま |
| `alias ls / ll / la` | `-G` で色付き、`-F` で種別記号（`/` はフォルダ、`*` は実行ファイル）、`-h` でサイズを読みやすく表示 |
| `direnv hook zsh` | フォルダに入ると、そこの `.envrc` の環境変数を自動で読み込み、出ると戻す |
| LM Studio の PATH | LM Studio の CLI（`lms`）を使えるようにする |
| `# pnpm` 〜 `# pnpm end` | standalone 版 pnpm を PATH に追加する。この目印の 2 行は、pnpm のインストーラが既存の設定を見分けるのに使うので変えない |
| `mise activate zsh` | フォルダ移動のたびに `mise.toml` を見て Node などを切り替える。PATH の先頭を取る必要があるので、PATH を触る設定の中で最後に置く |
| モダン CLI | fzf、zoxide、delta、eza の別名、zsh-autosuggestions を、入っているときだけ有効にする（[cli-tools.md](cli-tools.md)） |
| 履歴の保存先 `HISTFILE` | `~/.local/state/zsh/history`。macOS 標準の `/etc/zshrc` が `~/.zsh_history` を指定するので、`.zshrc` の先頭で上書きする |
| `source $ZDOTDIR/local.zsh` | 秘密情報やマシン固有の設定を読み込む（ファイルがなければ何もしない） |

## プロンプト（starship）

2026-09-23 に Powerlevel10k から starship に移行した。Powerlevel10k は開発がほぼ止まっているため。
見た目は以前の Powerlevel10k（classic、dark、2 行、右端に枠線）を、starship の標準機能だけで再現している。

```
 ~/Dev/Github/dotfiles   master ·························· ✘ 1  5s   18:53:37  ─╮
❯                                                                                  ─╯
```

### config/starship.toml の意味

| 設定 | 意味 |
| --- | --- |
| `format` | 1 行目の並び。左にフォルダと git、`$fill` で間を埋め、右に状態と時刻、行末に `─╮`。2 行目は入力欄 |
| `right_format` | 2 行目の右端の `─╯` |
| `add_newline = false` | コマンドの間に空行を入れない（Powerlevel10k と同じ） |
| `[fill]` | 左右の間を `·`（色 240）で埋める |
| 各項目の `style` の `bg:236` | 濃いグレーの帯。Powerlevel10k の背景色と同じ番号 |
| `` / `` | 帯の端の矢印と、項目の間の細い区切り（Nerd Font の記号） |
| `[directory]` | フォルダ。色 31、git リポジトリの根元は色 39 の太字、途中は色 103。4 階層を超えると `…/` で省略 |
| `[git_branch]` / `[git_status]` | ブランチ名（色 76）と変更の状態（色 178） |
| `[status]` | 直前のコマンドが失敗したときだけ `✘ 終了コード` を赤（色 160）で表示 |
| `[cmd_duration]` | 3 秒以上かかったコマンドの実行時間 |
| `[jobs]` / `[direnv]` | バックグラウンドのジョブ数、direnv の読み込み状態。該当するときだけ表示 |
| `[python]` / `[nodejs]` | そのフォルダが Python・Node のプロジェクトのときだけバージョンを表示 |
| `[time]` | 時刻（色 66） |
| `[character]` | 入力欄の `❯`。直前が成功なら緑（76）、失敗なら赤（196） |

色の番号は 256 色の番号。記号は Nerd Font の文字なので、ターミナルのフォントが Nerd Font（Ghostty の設定では BlexMono Nerd Font）でないと四角く表示される。

### 変えるとき

`config/starship.toml` を編集すると、次にプロンプトが表示されるときから反映される。設定の一覧は `starship print-config` で見られる。

撤去した Powerlevel10k の設定（`~/.p10k.zsh`）とテーマ本体（`~/powerlevel10k`）は、`~/.local/state/dotfiles/backup/` に退避してある。

## 秘密情報の扱い

トークンや API キーは `home/zshrc` に**絶対に書かない**。書く場合は `~/.config/zsh/local.zsh` に置く。

```zsh
# ~/.config/zsh/local.zsh の例: 値を直接書かず、1Password から取り出す
# export SOME_API_KEY="$(op read 'op://Private/Some API/credential')"
```

### GITHUB_PAT（2026-09-23 に削除）

以前は `~/.zshrc.local`（現在の `~/.config/zsh/local.zsh`）で GitHub のトークンを `GITHUB_PAT` に入れていた。次の理由で削除した。

- この変数を読んでいるツールが見つからなかった（Codex の GitHub プラグインが読むのは別名の `GITHUB_PAT_TOKEN`）
- 環境変数に入れると、この Mac で動くすべてのプログラム（npm のインストール処理や AI エージェントなど）が読める。
  GitHub CLI のトークンは全リポジトリへの書き込み権限を持つため、漏れたときの影響が大きい

GitHub CLI のログイン情報はキーチェーンに保管されたまま使える。トークンが必要なツールが出てきたら、
そのツールに必要な権限だけを持つ専用トークンを作り、そのツールの設定の中だけで使う。

## PATH の優先順位（新しいターミナルを開いた直後）

```
1. mise が管理する Node        ~/.local/share/mise/installs/node/24/bin
2. standalone pnpm             ~/Library/pnpm/bin
3. 自分で入れたコマンド         ~/.local/bin
4. Homebrew                    /opt/homebrew/bin
5. macOS 標準                  /usr/bin など
6. Volta（撤去予定）            ~/.volta/bin
```

確認コマンド：

```bash
which -a node pnpm       # 先頭が実際に使われるもの
echo $PATH | tr : '\n'   # PATH を 1 行ずつ表示
```

## 戻し方

`install.sh` がリンクを作るとき、元のファイルは `~/.local/state/dotfiles/backup/<日時>/.zshenv` のように退避される。

```bash
rm ~/.zshenv && mv ~/.local/state/dotfiles/backup/<日時>/.zshenv ~/.zshenv
```
