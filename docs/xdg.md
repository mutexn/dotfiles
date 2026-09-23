# ホームディレクトリのドットファイル集約（XDG Base Directory）

**状態：未着手（実機で検証してから標準化する）**

## 目的

ホームディレクトリに `.gitconfig` や `.zsh_history` などが散らばっているのを、
決まった 4 つの場所にまとめる。この置き場所のルールを XDG Base Directory と呼ぶ。

| 種類 | 置き場所 | 環境変数 |
| --- | --- | --- |
| 設定 | `~/.config` | `XDG_CONFIG_HOME` |
| データ | `~/.local/share` | `XDG_DATA_HOME` |
| 履歴などの状態 | `~/.local/state` | `XDG_STATE_HOME` |
| キャッシュ | `~/.cache` | `XDG_CACHE_HOME` |

## 仕組み

zsh が必ず読む `~/.zshenv` だけをホームに残し、そこで置き場所を切り替える。

```zsh
# ~/.zshenv
export XDG_CONFIG_HOME="$HOME/.config" XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state" XDG_CACHE_HOME="$HOME/.cache"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"   # .zshrc などを ~/.config/zsh/ から読ませる
```

## 移動計画

1 つずつ「環境変数を設定 → 新しいシェルで動作確認 → 旧ファイルを移動」の順で進める。

| 現在 | 移動先・方法 | 状態 |
| --- | --- | --- |
| `.zshrc` `.zprofile` | `~/.config/zsh/`（`ZDOTDIR`） | 未検証 |
| `.zsh_history` | `HISTFILE=$XDG_STATE_HOME/zsh/history` | 未検証 |
| `.zsh_sessions/` | `SHELL_SESSIONS_DISABLE=1`。macOS 標準のターミナル用の機能なので Ghostty では不要 | 未検証 |
| `.gitconfig` | `~/.config/git/config`。git が標準で読むので、ファイルを移すだけ | 未検証 |
| `.p10k.zsh` | starship に移行する場合は不要になる | 未検証 |
| `.vim/` `.viminfo` | `~/.config/vim/`（vim 9.1 以降が対応） | 未検証 |
| `.lesshst` | `LESSHISTFILE=$XDG_STATE_HOME/less/history` | 未検証 |
| `.node_repl_history` | `NODE_REPL_HISTORY=$XDG_STATE_HOME/node_repl_history` | 未検証 |
| `.psql_history` | `PSQL_HISTORY=$XDG_STATE_HOME/psql_history` | 未検証 |
| `.tig_history` | `~/.local/share/tig/` を作ると tig が自動でそちらを使う | 未検証 |
| `.npm/` | `NPM_CONFIG_CACHE=$XDG_CACHE_HOME/npm` | 未検証 |
| `.docker/` | `DOCKER_CONFIG=$XDG_CONFIG_HOME/docker`。Docker Desktop の再起動が必要 | 未検証 |
| `.boto` | `BOTO_CONFIG=$XDG_CONFIG_HOME/gcloud/boto` | 未検証 |
| `.composer/` | `COMPOSER_HOME=$XDG_CONFIG_HOME/composer` | 未検証 |
| `.volta/` | Volta を撤去するときに削除 | 未検証 |
| `.profile` | 中身を確認し、使っていなければ削除 | 未検証 |

## 動かさないもの

| ファイル | 理由 |
| --- | --- |
| `.ssh/` `.gnupg/` | 多くのツールがこの場所を前提にしており、移すと壊れやすい |
| `.Trash/` `.CFUserTextEncoding` | macOS が管理している |
| `.claude/` `.codex/` `.cursor/` `.gemini/` `.vscode/` `.warp/` `.ollama/` `.lmstudio/` など | 各アプリ固有の場所で、変更できないか、変更が推奨されていない |

## 見た目だけ隠す

Finder では、隠しファイルの表示をオフにすればドットファイルは見えなくなる（⌘⇧. で切り替え）。
ターミナルの `ls -a` では引き続き見える。
