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
./install.sh check              # 正しく設定されたかを確かめる
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
| `link` | 設定ファイルを実機の場所へリンク（元のファイルは `~/.local/state/dotfiles/backup/<日時>/` に退避） |
| `runtime` | mise で Node、uv で Python、standalone 版 pnpm |
| `macos` | macOS の設定 |
| `check` | 実機がリポジトリどおりかを確かめる。何も変更しない。すべてのステップを実行するときには含まれない |

## 基本方針

何をどの道具で入れるかは [docs/toolchain.md](docs/toolchain.md) にまとめている。
新しいアプリやコマンドを入れる前に確認する。

## ファイルの対応表

| リポジトリ | 実機の場所 | 説明 |
| --- | --- | --- |
| `home/zshenv` | `~/.zshenv` | [docs/zsh.md](docs/zsh.md) |
| `home/zprofile` | `~/.config/zsh/.zprofile` | [docs/zsh.md](docs/zsh.md) |
| `home/zshrc` | `~/.config/zsh/.zshrc` | [docs/zsh.md](docs/zsh.md) |
| `home/gitconfig` | `~/.gitconfig` | [docs/git.md](docs/git.md) |
| `config/git/ignore` | `~/.config/git/ignore` | [docs/git.md](docs/git.md) |
| `config/gh/config.yml` | `~/.config/gh/config.yml` | [docs/git.md](docs/git.md) |
| `config/mise/config.toml` | `~/.config/mise/config.toml` | [docs/mise.md](docs/mise.md) |
| `config/starship.toml` | `~/.config/starship.toml` | [docs/zsh.md](docs/zsh.md#プロンプトstarship) |
| `config/uv/uv.toml` | `~/.config/uv/uv.toml` | [docs/python.md](docs/python.md) |
| `config/ghostty/config` | `~/Library/Application Support/com.mitchellh.ghostty/config` | [docs/terminal-and-input.md](docs/terminal-and-input.md) |
| `config/karabiner/` | `~/.config/karabiner/` | [docs/terminal-and-input.md](docs/terminal-and-input.md) |
| `macos/defaults.sh` | macOS のシステム設定 | [docs/macos.md](docs/macos.md) |
| `claude/CLAUDE.md` など | `~/.claude/` の一部 | [docs/claude.md](docs/claude.md) |
| `Brewfile` | Homebrew のインストール一覧 | [docs/brew.md](docs/brew.md)、[docs/apps.md](docs/apps.md) |

### ファイル名のドットについて

ドットを外しているのは**リポジトリ内の元ファイルの名前だけ**。
`install.sh link` を実行すると、実機にはドット付きの隠しファイルとしてリンクが作られる。

```
リポジトリ内（元ファイル）                 実機（install.sh が作るリンク）
~/Dev/Github/dotfiles/home/zshenv   ←──   ~/.zshenv
~/Dev/Github/dotfiles/home/gitconfig ←──  ~/.gitconfig
```

zsh や git は今までどおり `~/.zshenv` や `~/.gitconfig` を読む。
リンク先のリポジトリ内ファイルを編集すれば、そのまま実機に反映される。
リポジトリ側でドットを外しているのは、`ls` や GitHub の画面で隠れずに見えるようにするため。

## スクリプト実行後のディレクトリ構造

`→` はリポジトリ内のファイルへのシンボリックリンク。それ以外は元からあるものか、各ツールが作るもの。

```
~/
├── .zshenv    → ~/Dev/Github/dotfiles/home/zshenv   # ホームに残す zsh のファイルはこれだけ
├── .gitconfig → ~/Dev/Github/dotfiles/home/gitconfig
├── .config/
│   ├── zsh/
│   │   ├── .zprofile     → ~/Dev/Github/dotfiles/home/zprofile
│   │   ├── .zshrc        → ~/Dev/Github/dotfiles/home/zshrc
│   │   └── local.zsh              # 秘密情報・マシン固有の設定用。リンクではなく実機だけに置く
│   ├── git/ignore        → ~/Dev/Github/dotfiles/config/git/ignore
│   ├── gh/
│   │   ├── config.yml    → ~/Dev/Github/dotfiles/config/gh/config.yml
│   │   └── hosts.yml              # gh auth login が作るログイン情報。リンクしない
│   ├── mise/config.toml  → ~/Dev/Github/dotfiles/config/mise/config.toml
│   ├── starship.toml     → ~/Dev/Github/dotfiles/config/starship.toml
│   ├── uv/uv.toml        → ~/Dev/Github/dotfiles/config/uv/uv.toml
│   └── karabiner/        → ~/Dev/Github/dotfiles/config/karabiner/   # フォルダごとリンク
├── Library/
│   ├── Application Support/com.mitchellh.ghostty/
│   │   └── config        → ~/Dev/Github/dotfiles/config/ghostty/config
│   └── pnpm/                      # install.sh runtime が入れる standalone 版 pnpm
├── .local/
│   ├── bin/python3                # uv が作る既定の Python へのリンク
│   ├── share/
│   │   ├── mise/                  # mise が入れた Node
│   │   ├── uv/python/             # uv が入れた Python
│   │   └── tig/                   # tig の履歴
│   └── state/
│       ├── zsh/history            # zsh のコマンド履歴
│       ├── less_history など       # 各ツールの履歴
│       └── dotfiles/backup/       # install.sh link が退避したファイル
└── Dev/Github/dotfiles/           # このリポジトリ（リンクの実体）
    ├── install.sh
    ├── Brewfile
    ├── macos/defaults.sh
    ├── home/                      # ホーム直下に置くファイル（ドットなしの名前）
    ├── config/                    # ~/.config などに置くファイル
    └── docs/
```

置き換える前のファイルは `~/.local/state/dotfiles/backup/<日時>/` の下に、ホームからの相対パスのまま退避される。
例：`~/.gitconfig` は `~/.local/state/dotfiles/backup/20260923120000/.gitconfig` になる。
元の場所の隣に置かないのは、`~/.claude/skills` のように、ツールがフォルダ内のものをすべて読み込んでしまう場所があるため。
問題なく動くことを確認したら削除してよい。

## 動作確認（install.sh check）

実機がリポジトリどおりになっているかを、読み取りだけで確かめる。設定を変えたあとや、新しい Mac のセットアップ後に実行する。
問題があれば `NG` と表示され、終了コードが 1 になる。

| 確かめる対象 | 内容 |
| --- | --- |
| リンク | 対応表のすべての場所が、リポジトリ内のファイルへのリンクになっているか |
| zsh | 設定ファイルに文法エラーがないか。新しいシェルで node・pnpm・python3 が mise・standalone 版・uv から使われるか |
| git / GitHub CLI | git が `~/.gitconfig` を読むか。共通の無視設定が実際に効くか。gh が設定を読むか |
| mise / uv | mise が全体設定を読むか。uv が自分で入れた Python を使うか |
| アプリ | Ghostty の設定にエラーがないか。Karabiner が設定を読めているか |
| Homebrew | Brewfile のコマンドとアプリがすべて入っているか。新しい版があるかどうかは見ない。App Store アプリは見ない |

リンクを個別に確かめるときは `ls -la` を使う。

```bash
ls -la ~/.zshenv
# lrwxr-xr-x ... /Users/mutexn/.zshenv -> /Users/mutexn/Dev/Github/dotfiles/home/zshenv
```

## 秘密情報

トークンや API キーはリポジトリに入れない。`~/.config/zsh/local.zsh` に置く（[docs/zsh.md](docs/zsh.md#秘密情報の扱い)）。

このリポジトリは**公開**している。次のものも書かない。

- 取引先の名前、社内リポジトリの名前、仕事のプロジェクト名。例として挙げるときは「旧プロジェクト 2 件」のように一般的に書く
- 社内のサーバー名、IP アドレス、社内 URL

設定ファイルはリポジトリへのリンクなので、ツールが zsh の設定や `~/.gitconfig` に書き込んだ内容はそのままリポジトリの変更になる。
コミット前に `git diff` で、意図しない行が追加されていないかを確認する。

### GitHub 側の設定（2026-09-23）

| 設定 | 内容 |
| --- | --- |
| 秘密情報スキャン・プッシュ保護 | 有効。トークンなどを含む push は GitHub が止める |
| master のルール「Protect master」 | 強制 push と削除を禁止。履歴を書き換える必要があるときだけ、Settings > Rules で一時的に無効にする |
| GitHub Actions | ワークフローの既定の権限は読み取りだけ。ワークフローはプルリクエストを承認できない |
| 共同作業者・デプロイキー・Webhook | なし。push できるのは本人だけ |

zsh の設定などはリポジトリへのリンクなので、master に入った変更は `git pull` した時点で実機のシェルに反映される。
他の Mac で `git pull` するときは、先に `git log -p HEAD..origin/master` で差分を確認する。

## 実機で検証してから標準化する

新しい設定は次の手順で取り入れる。

1. 実機で試す（元のファイルは退避しておく）
2. 数日使って問題がないか確かめる
3. 問題なければリポジトリに取り込み、docs に説明を書く
4. 合わなければ元に戻し、docs に「不採用」と理由を残す

| 項目 | 状態 | 説明 |
| --- | --- | --- |
| 今の設定の取り込み | 完了 | 挙動を変えずに取り込み、2026-09-23 に実機をリンクへ置き換えた |
| アプリの見直し | 完了（Shottr は試用中） | [docs/apps.md](docs/apps.md) |
| モダン CLI（fzf、zoxide、ripgrep、fd、bat、eza、git-delta、zsh-autosuggestions） | 採用（2026-09-23） | [docs/cli-tools.md](docs/cli-tools.md) |
| git の推奨設定（既定ブランチ main、pull 時 rebase など） | 試用中（2026-09-23 開始）。設定は実機の `~/.config/git/config` だけに置いている | |
| プロンプトを starship に移行 | 採用（2026-09-23）。Powerlevel10k の見た目を再現し、Powerlevel10k は撤去 | [docs/zsh.md](docs/zsh.md#プロンプトstarship) |
| ホームのドットファイル集約 | 試用中（2026-09-23 開始）。zsh と各種履歴を移動 | [docs/xdg.md](docs/xdg.md) |
| Python を uv に集約 | 完了（既存プロジェクト 1 件の仮想環境の作り直しは残り） | [docs/python.md](docs/python.md) |
| Volta 撤去 | 見送り（2026-09-23）。移行できないプロジェクトがあるため残す | [docs/mise.md](docs/mise.md) |
| Claude Code の設定を管理 | 完了。CLAUDE.md・settings.json・ステータスライン・自作スキルを管理 | [docs/claude.md](docs/claude.md) |
| CI で検証 | 完了（2026-09-23） | [docs/ci.md](docs/ci.md) |
