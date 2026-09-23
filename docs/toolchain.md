# ツールとパッケージ管理の基本方針

2026-09-23 策定。この Mac で「何を、どの道具で入れるか」の決まりごと。
個別の詳細は各ページ（[brew.md](brew.md)、[mise.md](mise.md)、[python.md](python.md)、[cli-tools.md](cli-tools.md)）にある。

## 原則

1. **1 つの対象は 1 つの道具で管理する。** 同じものを 2 つの道具で管理すると、どちらが使われているか分からなくなり、
   片方の更新でもう片方が壊れる。2026-07 の pnpm 障害（corepack と brew の二重管理）がこの例
2. **入れたものは宣言ファイルに書く。** 手で入れたものは新しい Mac で再現できない。
   Brewfile、`config/mise/config.toml`、`install.sh` のどれかに必ず載せる
3. **プロジェクトの依存はプロジェクトに閉じ込める。** バージョンはプロジェクト内のファイルで固定し、
   マシン全体に入れたものに頼らない
4. **試してから標準化する。** 新しい道具は実機で数日使い、問題なければこの表に加える

## 担当表

| 対象 | 道具 | 宣言する場所 |
| --- | --- | --- |
| Mac アプリ | Homebrew（cask） | `Brewfile` |
| App Store アプリ | mas | `Brewfile` |
| フォント | Homebrew（cask） | `Brewfile` |
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
| 公式以外の `curl ... \| sh` でのインストール | 中身を確認しづらい | Homebrew。Homebrew 本体と pnpm の公式インストーラだけは例外 |

## 今の Mac でずれているところ（2026-09-23 時点）

| 項目 | 状態 | 対応案 |
| --- | --- | --- |
| Marp CLI | 2026-09-23 に Homebrew の `marp-cli` へ移行済み | 完了 |
| Homebrew の node | bitwarden-cli の依存として残る | 直接は使わない。`npm -g` で入れたものはもうない |
| Volta | 2 プロジェクトが `volta` キーで Node を固定 | 移行できないため残す。新しいプロジェクトでは使わない（[mise.md](mise.md)） |
| `~/.composer` | 2026-09-23 にゴミ箱へ移動済み | 完了 |
| uv 本体 | 2025-12 の版で古い | `brew upgrade uv` |
| 既存プロジェクト 1 件の `.venv` | Homebrew の Python で作られている | uv で作り直す（[python.md](python.md)） |
| corepack | mise の Node 24 に同梱されている | 有効にしなければ害はない。何もしない |
| エディタの拡張機能 | VS Code 2 個、Cursor 10 個。どこにも記録していない | 下記「未決定」 |

## 未決定

- **エディタの設定と拡張機能の管理方法。** 各エディタの同期機能（VS Code の設定同期など）に任せるか、
  dotfiles に一覧を持つかを決める。Brewfile には `vscode "拡張機能ID"` と書く方法もある

## この方針をどこに置くか

方針は 2 種類に分かれ、それぞれ置き場所が違う。

| 種類 | 例 | 置き場所 |
| --- | --- | --- |
| **この Mac の方針** | 何をどの道具で入れるか、Homebrew の Python は使わない | この dotfiles（このページ） |
| **プロジェクト共通の規約** | `package.json` に `engines` と `packageManager` を書く、`uv.lock` をコミットする、corepack を使わない | チームで共有する場所。今は [mise.md](mise.md)・[python.md](python.md) に置いている |

プロジェクト共通の規約は、チームメンバーにも守ってもらう内容。
個人の dotfiles に置くと、メンバーから見えず、会社の方針として扱いにくい。
今は置き場所がないため dotfiles に置いているが、会社の開発ガイドライン用のリポジトリができたら移す。
社内の AI 活用ガイドライン用のリポジトリは範囲が違うため、移す先には向かない。

`~/Dev/Github/TOOLCHAIN.md` は [mise.md](mise.md) に統合済み。二重管理を避けるため、
2026-09-23 に「dotfiles の docs/mise.md に移動した」という案内だけにした。
