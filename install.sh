#!/usr/bin/env bash
# Mac セットアップスクリプト。何度実行しても安全（冪等）。詳細は README.md
#
# 使い方:
#   ./install.sh                 # すべてのステップを実行
#   ./install.sh --dry-run       # 実行せずに、行う操作だけを表示
#   ./install.sh link macos      # 指定したステップだけ実行
#
# ステップ: clt brew bundle link prompt runtime macos
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=0
BACKUP_SUFFIX="backup-$(date +%Y%m%d%H%M%S)"
ALL_STEPS=(clt brew bundle link prompt runtime macos)

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[warn]\033[0m %s\n' "$*" >&2; }

# dry-run 時は表示のみ、通常時は実行する
run() {
  if [[ $DRY_RUN -eq 1 ]]; then
    printf '    [dry-run] %s\n' "$*"
  else
    "$@"
  fi
}

# リポジトリ内のファイルを実機の場所へシンボリックリンクする。
# 既存ファイルがあれば <名前>.backup-<日時> に退避してから置き換える
link() {
  local src="$DOTFILES/$1" dest="$2"
  if [[ ! -e "$src" ]]; then
    warn "リポジトリに $1 がありません。スキップします"
    return
  fi
  if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
    printf '    ok    %s\n' "$dest"
    return
  fi
  [[ -d "$(dirname "$dest")" ]] || run mkdir -p "$(dirname "$dest")"
  if [[ -e "$dest" || -L "$dest" ]]; then
    printf '    backup %s -> %s.%s\n' "$dest" "$dest" "$BACKUP_SUFFIX"
    run mv "$dest" "$dest.$BACKUP_SUFFIX"
  fi
  printf '    link  %s -> %s\n' "$dest" "$src"
  run ln -s "$src" "$dest"
}

step_clt() {
  log "Xcode Command Line Tools"
  if xcode-select -p >/dev/null 2>&1; then
    echo "    インストール済み"
  else
    run xcode-select --install
    warn "ダイアログでインストールを完了してから、もう一度 ./install.sh を実行してください"
    exit 1
  fi
}

step_brew() {
  log "Homebrew"
  if [[ -x /opt/homebrew/bin/brew ]]; then
    echo "    インストール済み"
  else
    run /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
}

step_bundle() {
  log "Brewfile のアプリ・コマンドをインストール"
  if [[ $DRY_RUN -eq 1 ]]; then
    brew bundle check --file="$DOTFILES/Brewfile" --verbose || true
  else
    brew bundle --file="$DOTFILES/Brewfile"
  fi
}

step_link() {
  log "設定ファイルをリンク"
  # zsh（docs/zsh.md）
  link home/zshenv   "$HOME/.zshenv"
  link home/zprofile "$HOME/.zprofile"
  link home/zshrc    "$HOME/.zshrc"
  link home/p10k.zsh "$HOME/.p10k.zsh"
  # git（docs/git.md）
  link home/gitconfig  "$HOME/.gitconfig"
  link config/git/ignore "$HOME/.config/git/ignore"
  # mise（docs/mise.md）
  link config/mise/config.toml "$HOME/.config/mise/config.toml"
  # uv（docs/python.md）
  link config/uv/uv.toml "$HOME/.config/uv/uv.toml"
  # GitHub CLI。認証情報の hosts.yml はリンクしない（docs/git.md）
  link config/gh/config.yml "$HOME/.config/gh/config.yml"
  # Ghostty
  link config/ghostty/config "$HOME/Library/Application Support/com.mitchellh.ghostty/config"
  # Karabiner-Elements はファイル単位のリンクだと GUI 保存時に壊れるため、ディレクトリごとリンクする
  link config/karabiner "$HOME/.config/karabiner"
}

step_prompt() {
  log "Powerlevel10k"
  if [[ -d "$HOME/powerlevel10k" ]]; then
    echo "    インストール済み"
  else
    run git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/powerlevel10k"
  fi
}

step_runtime() {
  log "mise で Node などのランタイムをインストール"
  run mise install
  log "pnpm（standalone 版）"
  if [[ -x "$HOME/Library/pnpm/pnpm" ]]; then
    echo "    インストール済み"
  else
    run /bin/bash -c "curl -fsSL https://get.pnpm.io/install.sh | sh -"
  fi
}

step_macos() {
  log "macOS の設定"
  if [[ $DRY_RUN -eq 1 ]]; then
    echo "    [dry-run] macos/defaults.sh を実行"
  else
    "$DOTFILES/macos/defaults.sh"
  fi
}

main() {
  local steps=()
  for arg in "$@"; do
    case "$arg" in
      --dry-run) DRY_RUN=1 ;;
      -h|--help) sed -n '2,9p' "$0"; exit 0 ;;
      *) steps+=("$arg") ;;
    esac
  done
  [[ ${#steps[@]} -eq 0 ]] && steps=("${ALL_STEPS[@]}")

  for s in "${steps[@]}"; do
    if ! declare -F "step_$s" >/dev/null; then
      warn "不明なステップ: ${s}（使えるもの: ${ALL_STEPS[*]}）"
      exit 1
    fi
    "step_$s"
  done
  log "完了。新しいターミナルを開くか exec zsh で反映してください"
}

main "$@"
