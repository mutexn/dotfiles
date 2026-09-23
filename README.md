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
| `link` | 設定ファイルを実機の場所へリンク（元のファイルは `*.backup-<日時>` に退避） |
| `prompt` | プロンプトテーマ Powerlevel10k |
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
| `home/zprofile` | `~/.zprofile` | [docs/zsh.md](docs/zsh.md) |
| `home/zshrc` | `~/.zshrc` | [docs/zsh.md](docs/zsh.md) |
| `home/p10k.zsh` | `~/.p10k.zsh` | [docs/zsh.md](docs/zsh.md) |
| `home/gitconfig` | `~/.gitconfig` | [docs/git.md](docs/git.md) |
| `config/git/ignore` | `~/.config/git/ignore` | [docs/git.md](docs/git.md) |
| `config/gh/config.yml` | `~/.config/gh/config.yml` | [docs/git.md](docs/git.md) |
| `config/mise/config.toml` | `~/.config/mise/config.toml` | [docs/mise.md](docs/mise.md) |
| `config/uv/uv.toml` | `~/.config/uv/uv.toml` | [docs/python.md](docs/python.md) |
| `config/ghostty/config` | `~/Library/Application Support/com.mitchellh.ghostty/config` | [docs/terminal-and-input.md](docs/terminal-and-input.md) |
| `config/karabiner/` | `~/.config/karabiner/` | [docs/terminal-and-input.md](docs/terminal-and-input.md) |
| `macos/defaults.sh` | macOS のシステム設定 | [docs/macos.md](docs/macos.md) |
| `Brewfile` | Homebrew のインストール一覧 | [docs/brew.md](docs/brew.md)、[docs/apps.md](docs/apps.md) |

### ファイル名のドットについて

ドットを外しているのは**リポジトリ内の元ファイルの名前だけ**。
`install.sh link` を実行すると、実機にはドット付きの隠しファイルとしてリンクが作られる。

```
リポジトリ内（元ファイル）                 実機（install.sh が作るリンク）
~/Dev/Github/dotfiles/home/zshrc    ←──   ~/.zshrc
~/Dev/Github/dotfiles/home/gitconfig ←──  ~/.gitconfig
```

zsh や git は今までどおり `~/.zshrc` や `~/.gitconfig` を読む。
リンク先のリポジトリ内ファイルを編集すれば、そのまま実機に反映される。
リポジトリ側でドットを外しているのは、`ls` や GitHub の画面で隠れずに見えるようにするため。

## スクリプト実行後のディレクトリ構造

`→` はリポジトリ内のファイルへのシンボリックリンク。それ以外は元からあるものか、各ツールが作るもの。

```
~/
├── .zshenv    → ~/Dev/Github/dotfiles/home/zshenv
├── .zprofile  → ~/Dev/Github/dotfiles/home/zprofile
├── .zshrc     → ~/Dev/Github/dotfiles/home/zshrc
├── .zshrc.local                   # 秘密情報用。リンクではなく実機だけに置く
├── .p10k.zsh  → ~/Dev/Github/dotfiles/home/p10k.zsh
├── .gitconfig → ~/Dev/Github/dotfiles/home/gitconfig
├── powerlevel10k/                 # install.sh prompt が取得するテーマ本体
├── .config/
│   ├── git/ignore        → ~/Dev/Github/dotfiles/config/git/ignore
│   ├── gh/
│   │   ├── config.yml    → ~/Dev/Github/dotfiles/config/gh/config.yml
│   │   └── hosts.yml              # gh auth login が作るログイン情報。リンクしない
│   ├── mise/config.toml  → ~/Dev/Github/dotfiles/config/mise/config.toml
│   ├── uv/uv.toml        → ~/Dev/Github/dotfiles/config/uv/uv.toml
│   └── karabiner/        → ~/Dev/Github/dotfiles/config/karabiner/   # フォルダごとリンク
├── Library/
│   ├── Application Support/com.mitchellh.ghostty/
│   │   └── config        → ~/Dev/Github/dotfiles/config/ghostty/config
│   └── pnpm/                      # install.sh runtime が入れる standalone 版 pnpm
├── .local/
│   ├── bin/python3                # uv が作る既定の Python へのリンク
│   └── share/
│       ├── mise/                  # mise が入れた Node
│       └── uv/python/             # uv が入れた Python
└── Dev/Github/dotfiles/           # このリポジトリ（リンクの実体）
    ├── install.sh
    ├── Brewfile
    ├── macos/defaults.sh
    ├── home/                      # ホーム直下に置くファイル（ドットなしの名前）
    ├── config/                    # ~/.config などに置くファイル
    └── docs/
```

既存のファイルがあった場所には、退避したファイルが `~/.zshrc.backup-20260923120000` のような名前で残る。
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
ls -la ~/.zshrc
# lrwxr-xr-x ... /Users/mutexn/.zshrc -> /Users/mutexn/Dev/Github/dotfiles/home/zshrc
```

## 秘密情報

トークンや API キーはリポジトリに入れない。`~/.zshrc.local` に置く（[docs/zsh.md](docs/zsh.md#秘密情報の扱い)）。

このリポジトリは**公開**している。次のものも書かない。

- 取引先の名前、社内リポジトリの名前、仕事のプロジェクト名。例として挙げるときは「旧プロジェクト 2 件」のように一般的に書く
- 社内のサーバー名、IP アドレス、社内 URL

設定ファイルはリポジトリへのリンクなので、ツールが `~/.zshrc` や `~/.gitconfig` に書き込んだ内容はそのままリポジトリの変更になる。
コミット前に `git diff` で、意図しない行が追加されていないかを確認する。

GitHub の秘密情報スキャンとプッシュ保護を有効にしている（2026-09-23）。トークンなどを含む push は GitHub が止める。

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
| モダン CLI（fzf、zoxide、ripgrep、fd、bat、eza、git-delta、zsh-autosuggestions） | 未着手 | |
| git の推奨設定（既定ブランチ main、pull 時 rebase など） | 未着手 | |
| プロンプトを starship に移行 | 未着手 | Powerlevel10k は保守がほぼ止まっている |
| ホームのドットファイル集約 | 未着手 | [docs/xdg.md](docs/xdg.md) |
| Python を uv に集約 | 完了（既存プロジェクト 1 件の仮想環境の作り直しは残り） | [docs/python.md](docs/python.md) |
| Volta 撤去 | 未着手 | [docs/mise.md](docs/mise.md) |
| Claude Code の設定を管理 | 未着手 | |
| CI で install.sh を検証 | 未着手 | `install.sh check` を CI でも使う予定 |
