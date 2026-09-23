# Claude Code の設定

`~/.claude` には設定のほかに、会話履歴、認証情報、キャッシュ、プロジェクトごとのメモリなどが入っている。
そのため**フォルダ全体はリンクせず、自分で書いたファイルだけ**をリポジトリで管理する。

## Claude Code 本体

`install.sh runtime` が、公式のインストーラ（`curl -fsSL https://claude.ai/install.sh | bash`）で入れる。
本体は `~/.local/share/claude/versions/` に置かれ、`~/.local/bin/claude` がそこへのリンクになる。起動のたびに自動で更新される。
Homebrew では入れない（更新が `brew upgrade` 任せになるため）。Brewfile の `cask "claude"` はデスクトップアプリで、別物。

会社の Claude Code の管理者設定は、会社のリポジトリの手順で入れる。この dotfiles の対象外。

## ファイルの対応

| リポジトリ | 実機の場所 | 役割 |
| --- | --- | --- |
| `claude/CLAUDE.md` | `~/.claude/CLAUDE.md` | すべてのプロジェクトに適用される指示（応答言語、実装前の手順、Git のルールなど） |
| `claude/statusline-command.sh` | `~/.claude/statusline-command.sh` | 画面下部のステータスライン。フォルダ、モデル名、コンテキストの使用率、トークン数などを表示する |
| `claude/skills/setup-claude-settings/`（フォルダごと） | `~/.claude/skills/setup-claude-settings/` | 自作スキル。`/setup-claude-settings` でプロジェクト用の Claude Code 設定を作る |
| `claude/settings.json` | `~/.claude/settings.json` | 全体の設定。許可・禁止ルール、サンドボックス、モデル、ステータスライン、プラグインなど |

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
| 特定プロジェクト用の設定 | プロジェクトの `.claude/settings.local.json` に書く（下記） |

## settings.json について

### Claude Code が自分で書き換えることがある

`/config` や `/model` などで設定を変えると、Claude Code が `~/.claude/settings.json` を書き換える。
これはリポジトリのファイルの変更として現れるので、**コミット前に `git diff claude/settings.json` で中身を確認する**。
このリポジトリは公開しているため、社内のフォルダ名やプロジェクト名が入っていないかを特に見る。

Claude Code が書き換えるときに、リンクを普通のファイルに置き換えてしまう可能性もある。
`./install.sh check` で「リンクになっていない」と出たら、実機のファイルとリポジトリを見比べてから `./install.sh link` で張り直す。

### プロジェクト固有の設定

特定のプロジェクトだけで必要な設定（別フォルダへのアクセス許可など）は、全体の設定に書かず、
そのプロジェクトの `.claude/settings.local.json` に書く。このファイルは `config/git/ignore` で全リポジトリ共通に Git の対象外にしている。

```json
{
  "permissions": {
    "additionalDirectories": ["/Users/<ユーザー名>/Dev/Github/<別のプロジェクト>"]
  }
}
```

2026-09-23 に、全体の設定にあった社内プロジェクトのフォルダ指定を削除した。
そのフォルダは `~/Dev/Github` の中にあり、`~/Dev/Github` で起動したセッションからは設定なしで使える。
他のプロジェクトのセッションで使った記録はなかったため、どのプロジェクトにも移していない。

## 注意：リンク経由の編集

`settings.json` の許可ルールでは `~/.zshrc` や `~/.gitconfig` の編集を禁止している。ただし zsh と git の設定は今は `~/.config/zsh/` と `~/.config/git/` にあり、このルールには当たらない。
しかし実機のこれらのファイルは、このリポジトリのファイルへのリンクになっている。
リポジトリ側のパス（`~/Dev/Github/dotfiles/home/zshrc` など）への編集は禁止ルールに当たらない。
Claude Code にこのリポジトリを編集させるときは、変更内容を `git diff` で必ず確認する。
