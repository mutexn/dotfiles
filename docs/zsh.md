# zsh の設定

zsh は macOS 標準のシェル。起動の種類に応じて、決まった順番で設定ファイルを読む。

## ファイルの対応

| リポジトリ | 実機の場所 | いつ読まれるか |
| --- | --- | --- |
| `home/zshenv` | `~/.zshenv` | **すべての** zsh 起動時（スクリプト実行も含む）。最初に読まれる |
| `home/zprofile` | `~/.zprofile` | ログインシェル起動時（ターミナルアプリで新しいウインドウを開いたとき） |
| `home/zshrc` | `~/.zshrc` | 対話シェル起動時（プロンプトが出るとき） |
| `home/p10k.zsh` | `~/.p10k.zsh` | `.zshrc` から読まれる。プロンプトの見た目 |
| なし | `~/.zshrc.local` | `.zshrc` の最後に読まれる。**秘密情報とマシン固有の設定専用**。リポジトリに入れない |

ターミナルで新しいウインドウを開くと、次の順で読まれる。

```
.zshenv  →  .zprofile  →  .zshrc  →  (.p10k.zsh)  →  .zshrc.local
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
| p10k instant prompt | 前回のプロンプトを先に表示し、体感の起動時間を短くする。入力待ちをする処理はこれより上に書く |
| `source ~/powerlevel10k/...` | プロンプトのテーマ Powerlevel10k を読み込む。`install.sh prompt` で `~/powerlevel10k` に取得される |
| `alias ls / ll / la` | `-G` で色付き、`-F` で種別記号（`/` はフォルダ、`*` は実行ファイル）、`-h` でサイズを読みやすく表示 |
| `direnv hook zsh` | フォルダに入ると、そこの `.envrc` の環境変数を自動で読み込み、出ると戻す |
| LM Studio の PATH | LM Studio の CLI（`lms`）を使えるようにする |
| `# pnpm` 〜 `# pnpm end` | standalone 版 pnpm を PATH に追加する。この目印の 2 行は、pnpm のインストーラが既存の設定を見分けるのに使うので変えない |
| `mise activate zsh` | フォルダ移動のたびに `mise.toml` を見て Node などを切り替える。PATH の先頭を取る必要があるので、PATH を触る設定の中で最後に置く |
| `source ~/.zshrc.local` | 秘密情報やマシン固有の設定を読み込む（ファイルがなければ何もしない） |

### home/p10k.zsh

`p10k configure` の質問に答えると自動生成されるファイル。手で編集するより、
`p10k configure` をもう一度実行する方が安全。

## 秘密情報の扱い

トークンや API キーは `home/zshrc` に**絶対に書かない**。書く場合は `~/.zshrc.local` に置く。

```zsh
# ~/.zshrc.local の例: 値を直接書かず、コマンドで取り出す
export GITHUB_PAT="$(gh auth token)"
# 1Password に保存したものを取り出す場合
# export SOME_API_KEY="$(op read 'op://Private/Some API/credential')"
```

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

`install.sh` がリンクを作るとき、元のファイルは `~/.zshrc.backup-<日時>` のように退避される。

```bash
rm ~/.zshrc && mv ~/.zshrc.backup-<日時> ~/.zshrc
```
