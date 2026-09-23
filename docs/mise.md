# mise と Node.js / pnpm の管理方針

`~/Dev/Github/TOOLCHAIN.md`（2026-07-21 決定）の内容を dotfiles 向けにまとめたもの。

## ファイルの対応

| リポジトリ | 実機の場所 | いつ読まれるか |
| --- | --- | --- |
| `config/mise/config.toml` | `~/.config/mise/config.toml` | プロジェクトに `mise.toml` がない場所で使われる、全体の既定値 |

### config/mise/config.toml の意味

```toml
[tools]
node = "24"   # どこでも既定で Node 24 系の最新版を使う
```

mise は、今いるフォルダから上へたどって `mise.toml`・`.node-version`・`.nvmrc` を探す。
見つかればその指定を優先し、見つからなければこのファイルの値を使う。
仕組みは `home/zshrc` の `mise activate zsh` による（[zsh.md](zsh.md)）。

## 方針

| 対象 | 管理方法 |
| --- | --- |
| Node.js | **mise**。プロジェクトごとに `mise.toml` と `.node-version` で固定し、cd で自動切替 |
| pnpm 本体 | **standalone 版**（`~/Library/pnpm`）。`install.sh runtime` が公式インストーラで入れる |
| pnpm のバージョン | `package.json` の `packageManager` で固定。pnpm 10 以降が自動で切り替える |
| 本番（Vercel）の Node | `package.json` の `engines.node`。Vercel は mise.toml を読まないため必須 |
| 依存パッケージ | `pnpm-lock.yaml` をコミット |

Python は mise で管理せず uv に任せる（[python.md](python.md)）。

**corepack は使わない。** 2026-07 に、brew の corepack が作った pnpm の入口ファイルが
古い Node を指したまま残り、`pnpm: command not found` になる障害が起きたため。

### 他の選択肢を採らなかった理由

- **corepack**：Node 25 から同梱されなくなった。上記の障害の直接原因
- **Homebrew の pnpm**：`brew upgrade` で勝手に更新され、バージョンを固定しにくい
- **Volta**：pnpm 対応が実験的で、開発も停滞気味
- **pnpm に Node も管理させる方式**：`pnpm run` 経由でしか切り替わらず、ターミナルで直接叩く `node` が変わらない

## 新規プロジェクトで揃えるもの

```toml
# mise.toml
[tools]
node = "24"
```

```
# .node-version（mise 以外のツール向け。mise.toml と値を揃える）
24
```

```jsonc
// package.json
{
  "engines": { "node": ">=24.0.0 <25", "pnpm": ">=11.0.0 <12" },
  "packageManager": "pnpm@11.10.0"
}
```

`.gitignore` に `.pnpm-store/` を入れる。

### バージョンを上げるとき

- **Node のメジャー**：`mise.toml`・`.node-version`・`engines.node` の 3 か所を同時に更新
- **pnpm**：プロジェクト内で `pnpm self-update`。`packageManager` が更新されるのでコミット
- **依存**：`pnpm update`。lockfile の差分をコミット

## この Mac 固有の状態（2026-09-23 時点）

- brew の node は bitwarden-cli の依存として残る。直接は使わない。PATH で mise が先に来るので影響はない
- Marp CLI は 2026-09-23 に brew の node の `npm -g` から Homebrew の `marp-cli` に移した
- Volta も**残している**。`keanhealth_flora-hp` と `withbeauty_production` が package.json の `volta` キーで Node を固定中。この 2 つを mise 方式に移せば撤去できる
- corepack の入口ファイル（`/opt/homebrew/bin/pnpm`、`pnpx`）は削除済み

## トラブルシューティング

```bash
which -a node    # 先頭が mise のパスなら正常
which -a pnpm    # 先頭が ~/Library/pnpm/bin/pnpm なら正常
mise ls          # どの設定ファイルがどのバージョンを要求しているか
mise doctor      # mise activate が効いているかの診断
```

- **pnpm が見つからない**：古いターミナルの PATH が原因のことが多い。`exec zsh` で開き直す
- **`line 1: This: command not found`**：pnpm のバージョン自動切替が途中で中断された状態。
  `rm -rf ~/Library/pnpm/store/v11/links/@pnpm/exe/<バージョン>` のあと `pnpm -v`
- **VS Code などで pnpm が見つからない**：Dock から起動したアプリはシェル設定を読まない。アプリを再起動する

## チームメンバー向けの最小手順

```bash
brew install mise pnpm
echo 'eval "$(mise activate zsh)"' >> ~/.zshrc
exec zsh
git clone <repo> && cd <repo>
mise install
pnpm install
```

`corepack enable` は実行しない。
