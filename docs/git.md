# git と GitHub CLI の設定

## ファイルの対応

| リポジトリ | 実機の場所 | 役割 |
| --- | --- | --- |
| `home/gitconfig` | `~/.gitconfig` | git の全体設定（名前、メール、認証） |
| `config/git/ignore` | `~/.config/git/ignore` | すべてのリポジトリで共通に無視するファイル |
| `config/gh/config.yml` | `~/.config/gh/config.yml` | GitHub CLI（`gh`）の設定 |
| リンクしない | `~/.config/gh/hosts.yml` | `gh` のログイン情報。**秘密情報なのでリポジトリに入れない** |

git は `~/.gitconfig` と `~/.config/git/config` の両方を読む。
今は `~/.gitconfig` を使っている。`~/.config` への集約は [xdg.md](xdg.md) の検証項目。

## home/gitconfig の意味

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
rm ~/.gitconfig && mv ~/.gitconfig.backup-<日時> ~/.gitconfig
```
