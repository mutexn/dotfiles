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
| Claude Code 本体 | 公式のインストーラ（自動で更新される） | `install.sh` |
| JavaScript のパッケージ | pnpm | 各プロジェクトの `package.json` と `pnpm-lock.yaml` |
| Python 本体・仮想環境・パッケージ | uv | 全体：`config/uv/uv.toml`、プロジェクト：`.python-version`・`pyproject.toml`・`uv.lock` |
| Node 製のコマンド（Homebrew にないもの） | mise の `npm:` 指定 | `config/mise/config.toml` |
| Python 製のコマンド（Homebrew にないもの） | `uv tool install` | `install.sh` |
| エディタの設定・拡張機能 | この dotfiles（`config/vscode`、`config/cursor`） | `extensions.txt`、`settings.json`、`keybindings.json` |
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

## 設定ファイルをどう管理するか（2026-09-30 策定）

上の担当表は「何をどの道具で入れるか」の話。ここはその設定ファイルをどう扱うかの話。

判断の軸は **誰が正か（source of truth）**。リンクにするかどうかではない。
3 つの方式があり、このリポジトリでは既に使い分けている。

| 誰が正か | 方式 | 仕組み | 例 |
| --- | --- | --- | --- |
| リポジトリが正。ツールは読むだけ | **リンク** | `install.sh` の `LINKS`。実機はリポジトリへのシンボリックリンク | zshrc、gitconfig、starship.toml、uv.toml、ghostty/config、CLAUDE.md |
| リポジトリが正。実機には状態がある | **宣言 + 収束** | 一覧を宣言し、`install.sh` が足りないものだけ入れる。実機の状態は上書きしない | `Brewfile`、`config/vscode/extensions.txt` |
| ツールが正 | **管理しない + docs に手順** | リポジトリに入れず、手順だけ残す | `gh hosts.yml`（秘密情報）、既定ブラウザ（[apps.md](apps.md)）、macOS の手作業（[macos.md](macos.md)） |

### ツールが設定ファイルに書き戻す場合

リンクにすると、ツールの書き込みがそのままリポジトリの差分になる。
この場合はファイルごとに次から選ぶ。

| 選択肢 | 適する条件 | 採用例 |
| --- | --- | --- |
| **a. リンクのまま、ツールが書き戻す形をそのまま入れる** | 書き込みが決まった形で、頻度が低い。設定を再現する価値が大きい | `config/karabiner/`、`claude/settings.json` |
| **b. 管理しない + docs に設定内容を書く** | 管理したい設定が 1〜2 行しかない | herdr の `config.toml`（2026-09-30 検証中） |
| **c. 分割設定の仕組みを使い、自分の部分だけリンクする** | ツールに include や drop-in ディレクトリがある | 該当なし |

a を選ぶときは、**ツールが書き戻した形をそのままコミットする**。
`Store karabiner.json as Karabiner writes it back`（2026-09）がこの例で、
その形を入れておけば普段は差分が出なくなる。

差分が出たときは「自分の変更か、ツールの書き込みか」を `git diff` で毎回確認する。
`claude/settings.json` にプラグイン有効化が現れるのはこの性質によるもので、記録として妥当。

リンクの単位はツールの書き込み方で決める。
GUI の保存でファイルを置き換えるものはディレクトリごとリンクする（Karabiner がこれ）。
ただしソケットやログを同じディレクトリに作るツールでは、ディレクトリリンクは採れない。

### 「マスタファイルを置いて定期的に同期する」を採らない理由

リンクをやめてリポジトリにマスタを置き、実機とコピーで同期する案は採らない。理由は 3 つ。

1. **人間の規律に依存する。** 同期を忘れた時点でドリフトする
2. **ドリフトしたとき、どちらが正か判定できない。** 同期忘れなのか実機での意図的な変更なのかが区別できず、
   これは 2026-07 の pnpm 障害（どちらが使われているか分からなくなる）と同じ構造
3. **`install.sh check` が読み取りだけで検証できる、という強みを失う。** リンクなら
   「リンク先がリポジトリを指しているか」を見るだけで完全に検証できる。
   コピー方式では内容の diff が必要になり、差分の理由を機械判定できない

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

## 今の Mac でずれているところ（2026-09-23 時点）

| 項目 | 状態 | 対応案 |
| --- | --- | --- |
| Marp CLI | 2026-09-23 に Homebrew の `marp-cli` へ移行済み | 完了 |
| Homebrew の node | bitwarden-cli と contentful-cli の依存として残る | 直接は使わない。`npm -g` で入れたものはもうない |
| Volta | 2 プロジェクトが `volta` キーで Node を固定 | 移行できないため残す。新しいプロジェクトでは使わない（[mise.md](mise.md)） |
| `~/.composer` | 2026-09-23 にゴミ箱へ移動済み | 完了 |
| uv 本体 | 2026-09-23 に 0.12.18 へ更新済み | 完了。以後は `brew upgrade` で更新 |
| 既存プロジェクト 1 件の `.venv` | Homebrew の Python で作られている | uv で作り直す（[python.md](python.md)） |
| corepack | mise の Node 24 に同梱されている | 有効にしなければ害はない。何もしない |
| エディタの拡張機能 | 2026-09-23 に `config/vscode`・`config/cursor` の `extensions.txt` で管理を始めた | 完了（[editors.md](editors.md)） |
| herdr | 2026-09-30 に入れたエージェント多重化ツール。Brewfile に未宣言 | 数日使って判断する。続けるなら Brewfile に加える |

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

Claude Code には `claude/skills/toolchain/` をスキルとして置いている（[claude.md](claude.md)）。
パッケージ・コマンド・ランタイムを入れるときに読み込まれる。実体はこのページで、スキルには開発中に必要な要点だけを写している。
上の「今の Mac でずれているところ」のような時点情報は、追随が必要になるためスキルに入れない。

かつて `~/Dev/Github/TOOLCHAIN.md` にあった内容は [mise.md](mise.md) に統合済み。
二重管理を避けるため 2026-09-23 に案内だけの内容にし、その後ファイル自体もなくなっている。
