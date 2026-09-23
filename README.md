# dotfiles

mutexn の Mac（Apple Silicon）のセットアップ一式。
`install.sh` を実行すると、アプリのインストール、設定ファイルのリンク、macOS の設定まで行う。
何度実行しても安全（冪等）で、既存のファイルは上書きせずに退避する。

## 新しい Mac でのセットアップ

```bash
xcode-select --install          # git を使えるようにする。ダイアログで完了を待つ
git clone https://github.com/mutexn/dotfiles.git ~/Dev/Github/dotfiles
cd ~/Dev/Github/dotfiles
./install.sh --dry-run          # 何が行われるかを確認
./install.sh                    # 実行
gh auth login                   # GitHub にログイン（git push に必要）
```

一部だけ実行することもできる。

```bash
./install.sh link               # 設定ファイルのリンクだけ
./install.sh bundle macos       # アプリと macOS 設定だけ
```

| ステップ | 内容 |
| --- | --- |
| `clt` | Xcode Command Line Tools |
| `brew` | Homebrew 本体 |
| `bundle` | Brewfile のアプリとコマンド |
| `link` | 設定ファイルを実機の場所へリンク（元のファイルは `*.backup-<日時>` に退避） |
| `prompt` | プロンプトテーマ Powerlevel10k |
| `runtime` | mise で Node、standalone 版 pnpm |
| `macos` | macOS の設定 |

## ファイルの対応表

| リポジトリ | 実機の場所 | 説明 |
| --- | --- | --- |
| `home/zshenv` | `~/.zshenv` | [docs/zsh.md](docs/zsh.md) |
| `home/zprofile` | `~/.zprofile` | [docs/zsh.md](docs/zsh.md) |
| `home/zshrc` | `~/.zshrc` | [docs/zsh.md](docs/zsh.md) |
| `home/p10k.zsh` | `~/.p10k.zsh` | [docs/zsh.md](docs/zsh.md) |
| `home/gitconfig` | `~/.gitconfig` | [docs/git.md](docs/git.md) |
| `config/git/ignore` | `~/.config/git/ignore` | [docs/git.md](docs/git.md) |
| `config/gh/config.yml` | `~/.config/gh/config.yml` | [docs/git.md](docs/git.md) |
| `config/mise/config.toml` | `~/.config/mise/config.toml` | [docs/mise.md](docs/mise.md) |
| `config/ghostty/config` | `~/Library/Application Support/com.mitchellh.ghostty/config` | [docs/terminal-and-input.md](docs/terminal-and-input.md) |
| `config/karabiner/` | `~/.config/karabiner/` | [docs/terminal-and-input.md](docs/terminal-and-input.md) |
| `macos/defaults.sh` | macOS のシステム設定 | [docs/macos.md](docs/macos.md) |
| `Brewfile` | Homebrew のインストール一覧 | [docs/brew.md](docs/brew.md)、[docs/apps.md](docs/apps.md) |
| `home/vimrc` | リンクしていない | 旧設定。残すか [docs/apps.md](docs/apps.md) で判断中 |

リポジトリ内のファイル名は先頭のドットを外している（`home/zshrc` → `~/.zshrc`）。
一覧で見やすくするためと、隠しファイルにしないため。

## 秘密情報

トークンや API キーはリポジトリに入れない。`~/.zshrc.local` に置く（[docs/zsh.md](docs/zsh.md#秘密情報の扱い)）。

## 実機で検証してから標準化する

新しい設定は次の手順で取り入れる。

1. 実機で試す（元のファイルは退避しておく）
2. 数日使って問題がないか確かめる
3. 問題なければリポジトリに取り込み、docs に説明を書く
4. 合わなければ元に戻し、docs に「不採用」と理由を残す

| 項目 | 状態 | 説明 |
| --- | --- | --- |
| 今の設定の取り込み | 完了 | 挙動を変えずに取り込んだ |
| アプリの見直し | 判断待ち | [docs/apps.md](docs/apps.md) |
| モダン CLI（fzf、zoxide、ripgrep、fd、bat、eza、git-delta、zsh-autosuggestions） | 未着手 | |
| git の推奨設定（既定ブランチ main、pull 時 rebase など） | 未着手 | |
| プロンプトを starship に移行 | 未着手 | Powerlevel10k は保守がほぼ止まっている |
| ホームのドットファイル集約 | 未着手 | [docs/xdg.md](docs/xdg.md) |
| Volta 撤去・Python を uv に集約 | 未着手 | [docs/mise.md](docs/mise.md) |
| Claude Code の設定を管理 | 未着手 | |
| CI で install.sh を検証 | 未着手 | |
