# Claude Code の設定

`~/.claude` には設定のほかに、会話履歴、認証情報、キャッシュ、プロジェクトごとのメモリなどが入っている。
そのため**フォルダ全体はリンクせず、自分で書いたファイルだけ**をリポジトリで管理する。

## ファイルの対応

| リポジトリ | 実機の場所 | 役割 |
| --- | --- | --- |
| `claude/CLAUDE.md` | `~/.claude/CLAUDE.md` | すべてのプロジェクトに適用される指示（応答言語、実装前の手順、Git のルールなど） |
| `claude/statusline-command.sh` | `~/.claude/statusline-command.sh` | 画面下部のステータスライン。フォルダ、モデル名、コンテキストの使用率、トークン数などを表示する |
| `claude/skills/setup-claude-settings/`（フォルダごと） | `~/.claude/skills/setup-claude-settings/` | 自作スキル。`/setup-claude-settings` でプロジェクト用の Claude Code 設定を作る |
| 未定 | `~/.claude/settings.json` | 全体の設定。取り込み方を検討中（下記） |

### ステータスラインについて

`settings.json` の `statusLine` から `bash ~/.claude/statusline-command.sh` として呼ばれる。
Claude Code から渡される JSON を `jq` で読んで表示を組み立てる。`jq` は macOS に標準で入っている（`/usr/bin/jq`）。
アイコンは Nerd Font の記号を使うので、ターミナルのフォントが Nerd Font でないと四角く表示される。

## リポジトリに入れないもの

| もの | 理由 |
| --- | --- |
| `projects/`（メモリを含む） | プロジェクトごとの記録。仕事の内容が含まれる |
| `history.jsonl`、`sessions/`、`file-history/` など | 会話や操作の履歴 |
| `~/.claude.json` | 認証情報や MCP サーバーの設定を含む |
| `plugins/`、`skills/synced/` | Claude Code や claude.ai が自動で管理している |
| `settings.json` の社内フォルダ指定 | このリポジトリは公開している |

## 注意：リンク経由の編集

`settings.json` の許可ルールでは `~/.zshrc` や `~/.gitconfig` の編集を禁止している。
しかし実機のこれらのファイルは、このリポジトリのファイルへのリンクになっている。
リポジトリ側のパス（`~/Dev/Github/dotfiles/home/zshrc` など）への編集は禁止ルールに当たらない。
Claude Code にこのリポジトリを編集させるときは、変更内容を `git diff` で必ず確認する。
