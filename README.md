# dotfiles

mutexn の Mac（Apple Silicon）のセットアップ一式。
`install.sh` を実行すると、アプリのインストール、設定ファイルのリンク、macOS の設定まで行う。
何度実行しても安全（冪等）で、既存のファイルは上書きせずに退避する。

## 新しい Mac でのセットアップ

```bash
xcode-select --install          # git を使えるようにする。ダイアログで完了を待つ
git clone https://github.com/mutexn/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh --dry-run          # 何が行われるかを確認
./install.sh                    # 実行
gh auth login                   # GitHub にログイン（git push に必要）
./install.sh check              # 正しく設定されたかを確かめる
```

置き場所は `~/.dotfiles` に固定する。`install.sh` はリンク先を自分自身の場所から決めるため、
別の場所から実行するとリンクがそちらに張り替わり、設定が二重管理になる。
別の場所にある状態で `link` を実行すると警告が出て、`check` では NG になる。

`./install.sh` は 1 時間ほどかかる。アプリのインストール中は、経過時間とダウンロード済みの容量を 10 秒ごとに表示する。
途中でアプリのインストーラが管理者パスワードを求めるので、ときどき画面を見る。
最後に、手で行うことの一覧を表示する。

一部だけ実行することもできる。

```bash
./install.sh link               # 設定ファイルのリンクだけ
./install.sh bundle macos       # アプリと macOS 設定だけ
```

### うまくいかないときは

- **一部のアプリが失敗した。** 警告を出して残りの手順は続き、最後に失敗した手順を表示する。
  通信の切断などが原因のことが多いので、`brew bundle --file=Brewfile` を実行し直すと、失敗したものだけ入る
- **`brew: command not found` と出る。** `link` を実行する前は、シェルに Homebrew の場所が設定されていない。
  `install.sh` は自分で設定するので影響しないが、自分で `brew` を打つときは次を実行する。`link` 後にターミナルを開き直せば不要になる

  ```bash
  eval "$(/opt/homebrew/bin/brew shellenv)"
  ```

- **App Store のアプリが `No apps found in the App Store for ADAM ID` で入らない。** そのアプリの ID が変わっている。
  `mas search <アプリ名>` で新しい ID を調べ、Brewfile を更新する（2026-09 に Keynote・Pages・Numbers で発生）
- **Gyazo が入らない。** インストーラを手で開く必要がある。`open /opt/homebrew/Caskroom/gyazo/*/Gyazo-*.pkg`
- **セットアップ後に手で行うこと。** Karabiner-Elements や AltTab などは、初回起動時にシステム設定で「入力監視」「アクセシビリティ」を許可する。
  Slack や 1Password などへのログインも手で行う

| ステップ | 内容 |
| --- | --- |
| `clt` | Xcode Command Line Tools |
| `brew` | Homebrew 本体 |
| `bundle` | Brewfile のアプリとコマンド |
| `link` | 設定ファイルを実機の場所へリンク（元のファイルは `~/.local/state/dotfiles/backup/<日時>/` に退避） |
| `runtime` | mise で Node、uv で Python、Claude Code、standalone 版 pnpm |
| `editor` | VS Code と Cursor の拡張機能のうち、足りないものを入れる |
| `macos` | macOS の設定 |
| `security` | ファイアウォール、ステルスモード、Touch ID で sudo、リモートデスクトップの自動起動停止。管理者パスワードを聞かれる |
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
| `config/git/config` | `~/.config/git/config` | [docs/git.md](docs/git.md) |
| `config/git/ignore` | `~/.config/git/ignore` | [docs/git.md](docs/git.md) |
| `config/gh/config.yml` | `~/.config/gh/config.yml` | [docs/git.md](docs/git.md) |
| `config/mise/config.toml` | `~/.config/mise/config.toml` | [docs/mise.md](docs/mise.md) |
| `config/starship.toml` | `~/.config/starship.toml` | [docs/zsh.md](docs/zsh.md#プロンプトstarship) |
| `config/uv/uv.toml` | `~/.config/uv/uv.toml` | [docs/python.md](docs/python.md) |
| `config/ghostty/config` | `~/Library/Application Support/com.mitchellh.ghostty/config` | [docs/terminal-and-input.md](docs/terminal-and-input.md) |
| `config/karabiner/` | `~/.config/karabiner/` | [docs/terminal-and-input.md](docs/terminal-and-input.md) |
| `config/vscode/`、`config/cursor/` | 各エディタの `settings.json`・`keybindings.json` | [docs/editors.md](docs/editors.md) |
| `macos/defaults.sh` | macOS のシステム設定 | [docs/macos.md](docs/macos.md) |
| `macos/security.sh` | ファイアウォール、ステルスモード、Touch ID で sudo | [docs/macos.md](docs/macos.md#セキュリティ設定macossecuritysh) |
| `claude/CLAUDE.md` など | `~/.claude/` の一部 | [docs/claude.md](docs/claude.md) |
| `Brewfile` | Homebrew のインストール一覧 | [docs/brew.md](docs/brew.md)、[docs/apps.md](docs/apps.md) |

### ファイル名のドットについて

ドットを外しているのは**リポジトリ内の元ファイルの名前だけ**。
`install.sh link` を実行すると、実機にはドット付きの隠しファイルとしてリンクが作られる。

```
リポジトリ内（元ファイル）                 実機（install.sh が作るリンク）
~/.dotfiles/home/zshenv   ←──   ~/.zshenv
~/.dotfiles/config/git/config ←──  ~/.config/git/config
```

zsh は今までどおり `~/.zshenv` を読む。
リンク先のリポジトリ内ファイルを編集すれば、そのまま実機に反映される。
リポジトリ側でドットを外しているのは、`ls` や GitHub の画面で隠れずに見えるようにするため。

## スクリプト実行後のディレクトリ構造

`→` はリポジトリ内のファイルへのシンボリックリンク。それ以外は元からあるものか、各ツールが作るもの。

```
~/
├── .zshenv    → ~/.dotfiles/home/zshenv   # ホームに残す zsh のファイルはこれだけ
├── .config/
│   ├── zsh/
│   │   ├── .zprofile     → ~/.dotfiles/home/zprofile
│   │   ├── .zshrc        → ~/.dotfiles/home/zshrc
│   │   └── local.zsh              # 秘密情報・マシン固有の設定用。リンクではなく実機だけに置く
│   ├── git/
│   │   ├── config        → ~/.dotfiles/config/git/config
│   │   └── ignore        → ~/.dotfiles/config/git/ignore
│   ├── gh/
│   │   ├── config.yml    → ~/.dotfiles/config/gh/config.yml
│   │   └── hosts.yml              # gh auth login が作るログイン情報。リンクしない
│   ├── mise/config.toml  → ~/.dotfiles/config/mise/config.toml
│   ├── starship.toml     → ~/.dotfiles/config/starship.toml
│   ├── uv/uv.toml        → ~/.dotfiles/config/uv/uv.toml
│   └── karabiner/        → ~/.dotfiles/config/karabiner/   # フォルダごとリンク
├── .claude/                       # Claude Code。自分で書いたものだけリンク
│   ├── CLAUDE.md         → ~/.dotfiles/claude/CLAUDE.md
│   ├── settings.json     → ~/.dotfiles/claude/settings.json
│   ├── statusline-command.sh → ~/.dotfiles/claude/statusline-command.sh
│   └── skills/setup-claude-settings/ → ~/.dotfiles/claude/skills/setup-claude-settings/
├── Library/
│   ├── Application Support/
│   │   ├── com.mitchellh.ghostty/config → ~/.dotfiles/config/ghostty/config
│   │   ├── Code/User/settings.json など   → ~/.dotfiles/config/vscode/
│   │   └── Cursor/User/settings.json など → ~/.dotfiles/config/cursor/
│   └── pnpm/                      # install.sh runtime が入れる standalone 版 pnpm
├── .local/
│   ├── bin/
│   │   ├── python3                # uv が作る既定の Python へのリンク
│   │   └── claude                 # install.sh runtime が入れる Claude Code
│   ├── share/
│   │   ├── mise/                  # mise が入れた Node
│   │   ├── uv/python/             # uv が入れた Python
│   │   └── tig/                   # tig の履歴
│   └── state/
│       ├── zsh/history            # zsh のコマンド履歴
│       ├── less_history など       # 各ツールの履歴
│       └── dotfiles/backup/       # install.sh link が退避したファイル
└── .dotfiles/                     # このリポジトリ（リンクの実体）
    ├── install.sh
    ├── Brewfile
    ├── macos/                     # defaults.sh（macOS の設定）、security.sh（セキュリティ設定）
    ├── home/                      # ホーム直下に置くファイル（ドットなしの名前）
    ├── config/                    # ~/.config などに置くファイル
    ├── claude/                    # ~/.claude に置くファイル
    ├── .github/workflows/ci.yml   # CI
    └── docs/
```

置き換える前のファイルは `~/.local/state/dotfiles/backup/<日時>/` の下に、ホームからの相対パスのまま退避される。
例：`~/.config/git/config` は `~/.local/state/dotfiles/backup/20260923120000/.config/git/config` になる。
元の場所の隣に置かないのは、`~/.claude/skills` のように、ツールがフォルダ内のものをすべて読み込んでしまう場所があるため。
問題なく動くことを確認したら削除してよい。

## 動作確認（install.sh check）

実機がリポジトリどおりになっているかを、読み取りだけで確かめる。設定を変えたあとや、新しい Mac のセットアップ後に実行する。
問題があれば `NG` と表示され、終了コードが 1 になる。

| 確かめる対象 | 内容 |
| --- | --- |
| リンク | 対応表のすべての場所が、リポジトリ内のファイルへのリンクになっているか |
| zsh | 設定ファイルに文法エラーがないか。node・pnpm・python3・Claude Code が想定の場所から使われるか。NG のときは「入っていない」か「PATH の順番が違う」かを区別して表示する |
| git / GitHub CLI | git が `~/.config/git/config` を読むか。`~/.gitconfig` が残っていないか。共通の無視設定が実際に効くか。gh が設定を読むか |
| mise / uv | mise が全体設定を読むか。uv が自分で入れた Python を使うか |
| アプリ | Ghostty の設定にエラーがないか。Karabiner が設定を読めているか |
| エディタ | VS Code と Cursor に、一覧の拡張機能がすべて入っているか |
| セキュリティ | FileVault、ファイアウォール、ステルスモード、Touch ID で sudo が有効か。リモートデスクトップが自動起動しないか |
| Homebrew | Brewfile のコマンドとアプリがすべて入っているか。新しい版があるかどうかは見ない。App Store アプリは、ID が今も有効かを確かめる |

リンクを個別に確かめるときは `ls -la` を使う。

```bash
ls -la ~/.zshenv
# lrwxr-xr-x ... /Users/mutexn/.zshenv -> /Users/mutexn/.dotfiles/home/zshenv
```

## 秘密情報

トークンや API キーはリポジトリに入れない。`~/.config/zsh/local.zsh` に置く（[docs/zsh.md](docs/zsh.md#秘密情報の扱い)）。

このリポジトリは**公開**している。次のものも書かない。

- 取引先の名前、社内リポジトリの名前、仕事のプロジェクト名。例として挙げるときは「旧プロジェクト 2 件」のように一般的に書く
- 社内のサーバー名、IP アドレス、社内 URL

設定ファイルはリポジトリへのリンクなので、ツールが zsh や git の設定に書き込んだ内容はそのままリポジトリの変更になる。
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
ただし `install.sh` の `LINKS` に新しい行が増えたときは、`git pull` だけではリンクが張られない。
`./install.sh link` を実行してから `check` で確かめる。

## 実機で検証してから標準化する

新しい設定は次の手順で取り入れる。

1. 実機で試す（元のファイルは退避しておく）
2. 数日使って問題がないか確かめる
3. 問題なければリポジトリに取り込み、docs に説明を書く
4. 合わなければ元に戻し、docs に「不採用」と理由を残す

| 項目 | 状態 | 説明 |
| --- | --- | --- |
| 今の設定の取り込み | 完了 | 挙動を変えずに取り込み、2026-09-23 に実機をリンクへ置き換えた |
| アプリの見直し | 完了 | [docs/apps.md](docs/apps.md) |
| モダン CLI（fzf、zoxide、ripgrep、fd、bat、eza、git-delta、zsh-autosuggestions） | 採用（2026-09-23） | [docs/cli-tools.md](docs/cli-tools.md) |
| git の推奨設定（既定ブランチ main、pull 時 rebase など） | 採用（2026-09-23） | [docs/git.md](docs/git.md) |
| プロンプトを starship に移行 | 採用（2026-09-23）。Powerlevel10k の見た目を再現し、Powerlevel10k は撤去 | [docs/zsh.md](docs/zsh.md#プロンプトstarship) |
| ホームのドットファイル集約 | 採用（2026-09-23）。zsh・git の設定と各種履歴を移動 | [docs/xdg.md](docs/xdg.md) |
| Python を uv に集約 | 完了（既存プロジェクト 1 件の仮想環境の作り直しは残り） | [docs/python.md](docs/python.md) |
| Volta 撤去 | 見送り（2026-09-23）。移行できないプロジェクトがあるため残す | [docs/mise.md](docs/mise.md) |
| Claude Code の設定を管理 | 完了。CLAUDE.md・settings.json・ステータスライン・自作スキルを管理 | [docs/claude.md](docs/claude.md) |
| CI で検証 | 完了（2026-09-23） | [docs/ci.md](docs/ci.md) |
| macOS の設定の追加（拡張子の表示、パスバー、Finder の英語表示、入力の自動変換の停止など 11 項目） | 採用（2026-09-23） | [docs/macos.md](docs/macos.md) |
| セキュリティ設定（FileVault、ファイアウォール、ステルスモード、Touch ID で sudo） | 完了（2026-09-23）。この Mac で `./install.sh security` を実行し、`check` で確認済み | [docs/macos.md](docs/macos.md#セキュリティ設定macossecuritysh) |
| バックアップ（Time Machine） | 使わない（2026-09-23 決定） | [docs/macos.md](docs/macos.md) |
