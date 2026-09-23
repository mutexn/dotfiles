---
name: setup-claude-settings
description: プロジェクトの Claude Code 設定ファイル（settings.json / settings.local.json / CLAUDE.md）を生成する
disable-model-invocation: true
---

# /setup-claude-settings

プロジェクトの Claude Code 設定を初期化します。
プロジェクトの技術スタックを自動検出し、最適化された設定ファイルと CLAUDE.md を生成します。

設計方針の詳細は `${CLAUDE_SKILL_DIR}/policy.md` を参照してください。

---

## 手順

### 1. プロジェクト構造の調査

以下を確認して技術スタックを把握してください（読み取りのみ）：

**ルートのファイル一覧を確認：**
```
ls -la
```

**言語・ランタイムの検出：**
- `package.json` → Node.js / TypeScript
- `pyproject.toml` / `setup.py` / `requirements.txt` → Python
- `Cargo.toml` → Rust
- `go.mod` → Go
- `*.gemspec` / `Gemfile` → Ruby
- `pom.xml` / `build.gradle` → Java / Kotlin

**パッケージマネージャーの検出：**
- `package-lock.json` → npm
- `yarn.lock` → Yarn
- `pnpm-lock.yaml` → pnpm
- `bun.lockb` → Bun
- `uv.lock` → uv (Python)
- `poetry.lock` → Poetry

**テストフレームワークの検出：**
- `jest.config.*` / `vitest.config.*` → Jest / Vitest
- `pytest.ini` / `conftest.py` / `pyproject.toml` の `[tool.pytest]` → pytest
- `*.test.ts` / `*.spec.ts` のパターン確認

**ビルド・インフラの検出：**
- `Makefile` → make
- `Dockerfile` / `docker-compose.yml` → Docker
- `.github/workflows/` → GitHub Actions
- `turbo.json` → Turborepo
- `nx.json` → Nx

**リンター・フォーマッターの検出：**
- `.eslintrc*` / `eslint.config.*` → ESLint
- `biome.json` → Biome
- `.prettierrc*` → Prettier
- `.ruff.toml` / `ruff.toml` → Ruff (Python)
- `.mypy.ini` / `mypy.ini` → mypy

**フレームワークの検出（package.json の dependencies を確認）：**
- `next` → Next.js
- `react` → React
- `vue` → Vue
- `fastapi` / `django` / `flask` → Python Web

**既存の Claude 設定を確認：**
- `.claude/settings.json` の有無
- `CLAUDE.md` の有無

---

### 2. 検出結果の提示と確認

調査結果をユーザーに提示してください：

```
## 検出結果

**言語 / ランタイム:** [検出した言語]
**パッケージマネージャー:** [検出したツール]
**テストフレームワーク:** [検出したツール]
**ビルドツール:** [検出したツール]
**リンター / フォーマッター:** [検出したツール]
**フレームワーク:** [検出したもの]

## 生成する設定

以下のファイルを生成します：
1. `.claude/settings.json` - プロジェクト固有の権限設定
2. `.claude/settings.local.json` - マシン固有の設定（gitignore 対象）
3. `CLAUDE.md` - プロジェクト固有の行動指示書

続行しますか？変更したい項目があれば教えてください。
```

既存の `.claude/settings.json` や `CLAUDE.md` がある場合は、上書きするか確認してください。

---

### 3. `.claude/settings.json` の生成（Project スコープ）

`${CLAUDE_SKILL_DIR}/templates/project-settings.json` を Read して内容を確認し、
検出した技術スタックに応じてコメントアウトを外して生成してください。

**User 設定（`~/.claude/settings.json`）との差分のみを記述すること。**

---

### 4. `.claude/settings.local.json` の生成（Local スコープ）

`${CLAUDE_SKILL_DIR}/templates/local-settings.json` を Read して内容を確認し、
そのまま `.claude/settings.local.json` として生成してください。

このファイルは git にコミットしません。生成後、以下を案内してください：
- `enabledMcpjsonServers` にプロジェクトで使う MCP サーバー名を追加する方法
- `model` キーでモデルを上書きできること（例: `"claude-opus-4-6"`）

---

### 5. `CLAUDE.md` の生成（プロジェクト固有）

検出した情報を元に以下の構成で生成してください：

```markdown
# [プロジェクト名]

## 概要

[package.json の description または README の最初の段落から抽出]

## 技術スタック

- **言語:** [検出した言語とバージョン]
- **フレームワーク:** [検出したフレームワーク]
- **パッケージマネージャー:** [検出したツール]
- **テスト:** [検出したフレームワーク]
- **リンター / フォーマッター:** [検出したツール]

## よく使うコマンド

\`\`\`bash
# 開発サーバー起動
[package.json の scripts.dev または相当するコマンド]

# ビルド
[package.json の scripts.build または相当するコマンド]

# テスト
[package.json の scripts.test または相当するコマンド]

# リント
[package.json の scripts.lint または相当するコマンド]
\`\`\`

## ディレクトリ構造

[ls コマンドの結果を元に主要ディレクトリを説明]

## 開発ガイドライン

[README や既存ドキュメントから抽出。なければ空欄]

## 注意事項

[既存の CLAUDE.md があればその内容を引き継ぐ]
```

---

### 6. `.gitignore` の更新

`.gitignore` に `.claude/settings.local.json` が含まれているか確認し、なければ追加してください。

```bash
grep -n "settings.local.json" .gitignore
```

含まれていない場合は、`.gitignore` の末尾に以下を追加してください：

```
# Claude Code local settings
.claude/settings.local.json
```

---

### 7. 完了報告

生成したファイルの内容をユーザーに提示し、確認を促してください：

```
## 生成完了

以下のファイルを生成しました：

- `.claude/settings.json` ← git にコミットしてチームと共有
- `.claude/settings.local.json` ← git には入れない（gitignore 済み）
- `CLAUDE.md` ← プロジェクト固有の指示書

**次のステップ：**
1. 生成した内容を確認し、必要に応じて修正してください
2. `.claude/settings.json` と `CLAUDE.md` を git にコミットしてください
3. `.claude/settings.local.json` の `enabledMcpjsonServers` に
   使用する MCP サーバー名を追加してください
```
