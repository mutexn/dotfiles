# git と GitHub CLI の設定

## ファイルの対応

| リポジトリ | 実機の場所 | 役割 |
| --- | --- | --- |
| `config/git/config` | `~/.config/git/config` | git の全体設定（名前、メール、認証、推奨設定） |
| `config/git/ignore` | `~/.config/git/ignore` | すべてのリポジトリで共通に無視するファイル |
| `config/gh/config.yml` | `~/.config/gh/config.yml` | GitHub CLI（`gh`）の設定 |
| リンクしない | `~/.config/gh/hosts.yml` | `gh` のログイン情報。**秘密情報なのでリポジトリに入れない** |

git は `~/.gitconfig` と `~/.config/git/config` の両方を読む。ホームを散らかさないよう `~/.config/git/config` だけを使う（[xdg.md](xdg.md)）。
`~/.gitconfig` があると git はそちらを優先して書き込むので、作られていたら中身を移して消す。

## config/git/config の意味

### 名前と認証

| 設定 | 意味 |
| --- | --- |
| `user.name` / `user.email` | コミットに記録される作者名とメールアドレス |
| `credential "https://github.com".helper` | GitHub への https 接続時のパスワードを `gh` から受け取る。空の `helper =` 行は、それより前に設定された認証方法を打ち消すためのもの |
| `credential "https://gist.github.com".helper` | Gist でも同じ |

`gh auth login` を済ませておけば、`git push` でパスワードを聞かれない。
新しい Mac では `install.sh` の後に一度だけ実行する。

```bash
gh auth login
```

### 推奨設定（2026-09-23 採用）

| 設定 | 変わること |
| --- | --- |
| `init.defaultBranch = main` | 新しく `git init` したリポジトリの最初のブランチが main になる。既存のリポジトリは変わらない |
| `fetch.prune = true` | GitHub で消えたブランチが、手元の一覧からも自動で消える |
| `pull.rebase = true` | `git pull` で手元のコミットとぶつかったとき、マージコミットを作らず、手元のコミットを上に積み直す |
| `rebase.autoStash = true` | 未コミットの変更があっても積み直しができる。変更は自動で退避して戻る |
| `push.autoSetupRemote = true` | 新しいブランチの初回 push で `-u origin ブランチ名` を書かなくてよい |
| `diff.algorithm = histogram` | 差分の区切り方が、より自然になる |
| `diff.colorMoved = default` | 場所を移動しただけの行を、別の色で表示する |
| `merge.conflictStyle = zdiff3` | 競合したとき、変更前の内容も一緒に表示する |
| `rerere.enabled = true` | 一度解決した競合を覚え、同じ競合を自動で解決する |
| `branch.sort = -committerdate` | `git branch` の一覧が、最近使った順に並ぶ |
| `commit.verbose = true` | コミットメッセージを書く画面に、コミットする差分も表示する |
| `interactive.diffFilter` / `delta.navigate` | `git add -p` の差分も delta で色付き表示。差分の表示中に n / N でファイル間を移動できる |

`pull.rebase` は、チームのリポジトリで「pull はマージで」と決まっている場合は、そのリポジトリだけ `git config pull.rebase false` で上書きする。

## config/git/ignore の意味

| 行 | 意味 |
| --- | --- |
| `**/.claude/settings.local.json` | Claude Code の個人用設定を、どのリポジトリでもコミットしない |
| `**/.claude/.cc-writes/` | Claude Code の作業用ファイルを、どのリポジトリでもコミットしない |

## config/gh/config.yml の意味

`gh` が自動生成したファイル。変更しているのは次の 2 点だけ。

| 設定 | 意味 |
| --- | --- |
| `git_protocol: https` | `gh repo clone` などで https を使う |
| `aliases.co: pr checkout` | `gh co 123` で PR #123 のブランチに切り替える |

## 戻し方

```bash
rm ~/.config/git/config && mv ~/.local/state/dotfiles/backup/<日時>/.config/git/config ~/.config/git/config
```
