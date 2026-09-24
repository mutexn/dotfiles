---
name: toolchain
description: この Mac で「何を、どの道具で入れるか」の方針。パッケージ・コマンド・ランタイム・アプリを入れるとき、または入れ方を変えるときに読む
---

# ツールチェーンの方針

この Mac の決まりごと。2026-09-23 策定。

担当表の全体、決定の経緯、今の Mac でずれているところは `~/.dotfiles/docs/toolchain.md` にある。
dotfiles のセッションではそちらも読む。他のプロジェクトでは作業ディレクトリの外になるため、このページの内容で判断する。

## 原則

1. **1 つの対象は 1 つの道具で管理する。** 同じものを 2 つの道具で管理すると、どちらが使われているか分からなくなり、
   片方の更新でもう片方が壊れる。2026-07 の pnpm 障害（corepack と brew の二重管理）がこの例
2. **入れたものは宣言ファイルに書く。** 手で入れたものは新しい Mac で再現できない。
   `Brewfile`、`config/mise/config.toml`、`install.sh` のどれかに必ず載せる
3. **プロジェクトの依存はプロジェクトに閉じ込める。** バージョンはプロジェクト内のファイルで固定し、
   マシン全体に入れたものに頼らない

## 何をどの道具で入れるか

| 対象 | 道具 | 宣言する場所 |
| --- | --- | --- |
| Mac アプリ、フォント | Homebrew（cask） | `Brewfile` |
| App Store アプリ | mas | `Brewfile` |
| コマンドラインツール | Homebrew（formula） | `Brewfile` |
| Node 本体 | mise | 全体：`config/mise/config.toml`、プロジェクト：`mise.toml` |
| pnpm 本体 | standalone 版 | `install.sh`。バージョンは各プロジェクトの `packageManager` |
| JavaScript のパッケージ | pnpm | 各プロジェクトの `package.json` と `pnpm-lock.yaml` |
| Python 本体・仮想環境・パッケージ | uv | 全体：`config/uv/uv.toml`、プロジェクト：`.python-version`・`pyproject.toml`・`uv.lock` |
| Node 製のコマンド（Homebrew にないもの） | mise の `npm:` 指定 | `config/mise/config.toml` |
| Python 製のコマンド（Homebrew にないもの） | `uv tool install` | `install.sh` |
| その他の言語（Go、Rust、Ruby、Java など） | 必要になったら mise | `config/mise/config.toml` またはプロジェクトの `mise.toml` |
| 秘密情報 | 1Password、`~/.config/zsh/local.zsh` | リポジトリには入れない |

### コマンドを入れるときの優先順位

1. Homebrew に formula があれば Homebrew（`brew search <名前>` で確認）
2. なければ、Node 製は mise の `npm:`、Python 製は `uv tool install`

```toml
# config/mise/config.toml に Node 製コマンドを宣言する例
[tools]
node = "24"
"npm:some-cli" = "latest"
```

## やらないこと

| やらないこと | 理由 | 代わりに |
| --- | --- | --- |
| `corepack enable` | 2026-07 の障害の原因。Node 25 で同梱も終了 | standalone 版 pnpm |
| `npm install -g` / `pnpm add -g` | どの Node に入ったか分からなくなり、Node の切り替えで消える | Homebrew か mise の `npm:` |
| `pip install`（仮想環境の外）、`sudo pip` | macOS や Homebrew の Python を壊す | uv |
| `brew install node` / `brew install python` をプロジェクト用に使う | `brew upgrade` で勝手に上がる | mise / uv |
| macOS 標準の Ruby・Python・Java を使う | 古く、更新できない | 必要なら mise / uv |
| Volta を新しく使う | 旧プロジェクトのためだけに残している | mise |
| 公式以外の `curl ... \| sh` でのインストール | 中身を確認しづらい | Homebrew。Homebrew 本体・pnpm・Claude Code の公式インストーラだけは例外 |

## プロジェクト側に書くこと

- `package.json` に `engines` と `packageManager` を書く
- `pnpm-lock.yaml`、`uv.lock` はコミットする
- Python は `.python-version` と `pyproject.toml` でバージョンを固定する

## 迷ったとき

- 表にない対象を新しい道具で入れたいときは、勝手に入れずユーザーに確認する
- 新しい道具は実機で数日使い、問題なければ `~/.dotfiles/docs/toolchain.md` の表に加える
