# Claude Code 設定スコープ設計方針

最終更新: 2026-03-28

---

## スコープと優先順位

| スコープ | ファイルパス | git コミット |
|---------|------------|------------|
| User | `~/.claude/settings.json` | しない（個人設定） |
| Project | `.claude/settings.json` | **する**（チーム共有） |
| Local | `.claude/settings.local.json` | しない（gitignore 対象） |

**優先順位:** Local > Project > User
**評価順序:** deny → ask → allow
**重要:** User の `deny` は Project の `allow` より強い。User に書いた deny はプロジェクト側で解除できない。

---

## 各スコープに置くもの

**User** — 全プロジェクト共通のルール
- セキュリティの絶対 deny（SSH・AWS・.env 等）
- 個人の UI・言語設定
- 常時許可する基本コマンド（ls・git log 系・Read 等）
- `defaultMode: plan`（全プロジェクトで安全方向を強制）

**Project** — チーム全員が従うルール
- プロジェクト固有のビルド・テスト・リントコマンド
- プロジェクト固有の追加 deny（本番設定ファイル保護等）
- `git merge --no-ff *`, `git worktree *`（全プロジェクト共通だが Project に置く）

**Local** — このマシン・この個人だけのルール
- `enabledMcpjsonServers`（マシン構成による MCP 許可）
- `model` 上書き（コスト・品質の個人判断）
- `sandbox` 無効化（Docker 非搭載マシン等）

---

## MCP サーバー管理の注意

- `~/.claude.json` に登録した User スコープの MCP サーバー（Notion・context7 等）は常時有効。`enabledMcpjsonServers` と無関係。
- `enabledMcpjsonServers` は `.mcp.json`（プロジェクト追加サーバー）のホワイトリスト。
- `enableAllProjectMcpServers: false`（User）により、未知プロジェクトの MCP サーバーを自動信頼しない。
