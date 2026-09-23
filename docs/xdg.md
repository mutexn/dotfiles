# ホームディレクトリのドットファイル集約（XDG Base Directory）

**状態：試用中（2026-09-23 開始）。zsh と各種履歴を移動済み。実機で数日使ってから標準化する**

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
| `.zshrc` `.zprofile` `.zshrc.local` | `~/.config/zsh/`（`ZDOTDIR`）。`.zshrc.local` は `local.zsh` に改名 | 試用中 |
| `.zsh_history` | `HISTFILE=$XDG_STATE_HOME/zsh/history`。中身は移動済み | 試用中 |
| `.zsh_sessions/` | `SHELL_SESSIONS_DISABLE=1`。macOS 標準のターミナル用の機能なので Ghostty では不要。既存分は退避 | 試用中 |
| `.gitconfig` | `~/.config/git/config`。git が標準で読むので、ファイルを移すだけ | 保留。git の推奨設定の試用で同じ場所を使っているため、試用が終わってから |
| `.p10k.zsh` | starship への移行で不要になり、2026-09-23 に撤去 | 完了 |
| `.vim/` `.viminfo` | vim は使っていない（neovim を使用）ため退避 | 試用中 |
| `.lesshst` | `LESSHISTFILE=$XDG_STATE_HOME/less_history`。中身は移動済み | 試用中 |
| `.node_repl_history` | `NODE_REPL_HISTORY=$XDG_STATE_HOME/node_repl_history` | 試用中 |
| `.psql_history` | `PSQL_HISTORY=$XDG_STATE_HOME/psql_history`。中身は移動済み | 試用中 |
| `.tig_history` | `~/.local/share/tig/` を作ると tig が自動でそちらを使う（`install.sh link` が作る）。中身は移動済み | 試用中 |
| `.npm/` | `NPM_CONFIG_CACHE=$XDG_CACHE_HOME/npm` | 見送り。Claude Code のサンドボックスが `~/.npm/_logs` への書き込みだけを許可しているため、場所を変えると npm のログが書けなくなる |
| `.docker/` | `DOCKER_CONFIG=$XDG_CONFIG_HOME/docker` | 見送り。Docker Desktop はシェルの環境変数を読まず、`~/.docker` を前提に動く |
| `.boto` | `BOTO_CONFIG=$XDG_CONFIG_HOME/gcloud/boto` | 見送り。Google Cloud の認証情報を含む可能性があるため触らない |
| `.composer/` | PHP を使っていないため、2026-09-23 にゴミ箱へ移動済み | 完了 |
| `.volta/` | Volta を撤去するときに削除 | 未検証 |
| `.profile` | bash 用で、中身は `zshrc` と重複していたため退避 | 試用中 |

## 動かさないもの

| ファイル | 理由 |
| --- | --- |
| `.ssh/` `.gnupg/` | 多くのツールがこの場所を前提にしており、移すと壊れやすい |
| `.Trash/` `.CFUserTextEncoding` | macOS が管理している |
| `.claude/` `.codex/` `.cursor/` `.gemini/` `.vscode/` `.warp/` `.ollama/` `.lmstudio/` など | 各アプリ固有の場所で、変更できないか、変更が推奨されていない |

## 見た目だけ隠す

Finder では、隠しファイルの表示をオフにすればドットファイルは見えなくなる（⌘⇧. で切り替え）。
ターミナルの `ls -a` では引き続き見える。

## 試用中の注意

- **試用を始める前から開いていたターミナル。** 起動時の設定のまま動いているので、閉じると `~/.zsh_history` を作り直すことがある。
  すべて開き直したあとに `~/.zsh_history` があれば、中身を新しい履歴に足して消す。

  ```bash
  cat ~/.zsh_history >> ~/.local/state/zsh/history && rm ~/.zsh_history
  ```

- **インストーラが `~/.zshrc` を作ることがある。** `~/.zshrc` に設定を追記する前提のインストーラは、ファイルがないと新しく作る。
  このファイルは読まれないので、中身を確認して必要なら `home/zshrc` に移し、`~/.zshrc` は消す。

## 元に戻すとき

退避したファイルは `~/.local/state/dotfiles/backup/<日時>/` にある。`home/zshenv` を試用前の版に戻し、
退避した `.zshrc` と `.zprofile` のリンク、各履歴ファイルをホームに戻す。

