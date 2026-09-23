#!/usr/bin/env bash
# Mac セットアップスクリプト。何度実行しても安全（冪等）。詳細は README.md
#
# 使い方:
#   ./install.sh                 # すべてのステップを実行
#   ./install.sh --dry-run       # 実行せずに、行う操作だけを表示
#   ./install.sh link macos      # 指定したステップだけ実行
#   ./install.sh security        # ファイアウォールと Touch ID で sudo（パスワードを聞かれる）
#   ./install.sh check           # 実機がリポジトリどおりかを確かめる（何も変更しない）
#
# ステップ: clt brew bundle link runtime editor macos security check
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=0
# 置き換える前のファイルの退避先。元の場所の隣に置くと、ツールが読み込んでしまうことがあるため 1 か所にまとめる
BACKUP_DIR="$HOME/.local/state/dotfiles/backup/$(date +%Y%m%d%H%M%S)"
ALL_STEPS=(clt brew bundle link runtime editor macos security)
FAILED_STEPS=()

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
# 既存ファイルがあれば $BACKUP_DIR の下に、ホームからの相対パスのまま退避してから置き換える
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
    local backup="$BACKUP_DIR/${dest#"$HOME"/}"
    printf '    backup %s -> %s\n' "$dest" "$backup"
    run mkdir -p "$(dirname "$backup")"
    run mv "$dest" "$backup"
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
  elif ! brew bundle --file="$DOTFILES/Brewfile"; then
    # 1 つの失敗（通信の切断など）で残りの手順まで止めないよう、警告だけ出して先に進む
    FAILED_STEPS+=("bundle")
    warn "Brewfile の一部のインストールに失敗しました。残りの手順は続けます"
    warn "あとで brew bundle --file=\"$DOTFILES/Brewfile\" を実行し直すと、失敗したものだけ入れ直せます"
  fi
}

# リンクの一覧。「リポジトリ内のパス|実機の場所」の形で書く。link と check の両方が使う
LINKS=(
  # zsh（docs/zsh.md）
  "home/zshenv|$HOME/.zshenv"
  "home/zprofile|$HOME/.config/zsh/.zprofile"
  "home/zshrc|$HOME/.config/zsh/.zshrc"
  # git（docs/git.md）
  "config/git/config|$HOME/.config/git/config"
  "config/git/ignore|$HOME/.config/git/ignore"
  # mise（docs/mise.md）
  "config/mise/config.toml|$HOME/.config/mise/config.toml"
  # starship（docs/zsh.md）
  "config/starship.toml|$HOME/.config/starship.toml"
  # uv（docs/python.md）
  "config/uv/uv.toml|$HOME/.config/uv/uv.toml"
  # GitHub CLI。認証情報の hosts.yml はリンクしない（docs/git.md）
  "config/gh/config.yml|$HOME/.config/gh/config.yml"
  # Ghostty（docs/terminal-and-input.md）
  "config/ghostty/config|$HOME/Library/Application Support/com.mitchellh.ghostty/config"
  # Karabiner-Elements はファイル単位のリンクだと GUI 保存時に壊れるため、ディレクトリごとリンクする
  "config/karabiner|$HOME/.config/karabiner"
  # エディタ（docs/editors.md）
  "config/vscode/settings.json|$HOME/Library/Application Support/Code/User/settings.json"
  "config/vscode/keybindings.json|$HOME/Library/Application Support/Code/User/keybindings.json"
  "config/cursor/settings.json|$HOME/Library/Application Support/Cursor/User/settings.json"
  "config/cursor/keybindings.json|$HOME/Library/Application Support/Cursor/User/keybindings.json"
  # Claude Code（docs/claude.md）。~/.claude 全体ではなく、自分で書いたものだけをリンクする
  "claude/CLAUDE.md|$HOME/.claude/CLAUDE.md"
  "claude/settings.json|$HOME/.claude/settings.json"
  "claude/statusline-command.sh|$HOME/.claude/statusline-command.sh"
  "claude/skills/setup-claude-settings|$HOME/.claude/skills/setup-claude-settings"
)

step_link() {
  log "設定ファイルをリンク"
  # tig は ~/.local/share/tig があると、履歴をそこに保存する（docs/xdg.md）
  [[ -d "$HOME/.local/share/tig" ]] || run mkdir -p "$HOME/.local/share/tig"
  local entry
  for entry in "${LINKS[@]}"; do
    link "${entry%%|*}" "${entry#*|}"
  done
}

step_runtime() {
  log "mise で Node などのランタイムをインストール"
  run mise install
  log "uv で Python をインストールし、既定の python / python3 にする（docs/python.md）"
  run uv python install 3.14 --default
  log "Claude Code（公式のインストーラ。自動で更新される。docs/claude.md）"
  if [[ -x "$HOME/.local/bin/claude" ]]; then
    echo "    インストール済み"
  else
    run /bin/bash -c "curl -fsSL https://claude.ai/install.sh | bash"
  fi
  log "pnpm（standalone 版）"
  if [[ -x "$HOME/Library/pnpm/pnpm" ]]; then
    echo "    インストール済み"
  else
    run /bin/bash -c "curl -fsSL https://get.pnpm.io/install.sh | sh -"
  fi
}

# エディタの拡張機能の一覧（コメントと空行を除く）
editor_extensions() {
  grep -vE '^[[:space:]]*(#|$)' "$DOTFILES/config/$1/extensions.txt"
}

# 一覧にあって、まだ入っていない拡張機能を返す
missing_extensions() {
  local dir="$1" cli="$2" installed
  installed=" $("$cli" --list-extensions 2>/dev/null | tr '[:upper:]' '[:lower:]' | tr '\n' ' ') "
  editor_extensions "$dir" | while read -r id; do
    [[ "$installed" == *" $(tr '[:upper:]' '[:lower:]' <<<"$id") "* ]] || echo "$id"
  done
}

step_editor() {
  log "エディタの拡張機能（config/vscode・config/cursor の extensions.txt）"
  local pair dir cli id missing
  for pair in "vscode|code" "cursor|cursor"; do
    dir="${pair%%|*}" cli="${pair#*|}"
    if ! command -v "$cli" >/dev/null; then
      echo "    $cli コマンドがないためスキップ（アプリを入れてから再実行する）"
      continue
    fi
    missing="$(missing_extensions "$dir" "$cli")"
    if [[ -z "$missing" ]]; then
      echo "    $dir: すべて入っている"
      continue
    fi
    while read -r id; do
      run "$cli" --install-extension "$id"
    done <<<"$missing"
  done
}

step_macos() {
  log "macOS の設定"
  if [[ $DRY_RUN -eq 1 ]]; then
    echo "    [dry-run] macos/defaults.sh を実行"
  else
    "$DOTFILES/macos/defaults.sh"
  fi
}

step_security() {
  log "セキュリティ設定（ファイアウォール、ステルスモード、Touch ID で sudo）"
  if [[ $DRY_RUN -eq 1 ]]; then
    echo "    [dry-run] macos/security.sh を実行（管理者パスワードを聞かれる）"
  else
    "$DOTFILES/macos/security.sh"
  fi
}

# --- check: 実機がリポジトリどおりになっているかを確かめる（読み取りだけで、何も変更しない）---
CHECK_FAILED=0
pass() { printf '    \033[32mok\033[0m    %s\n' "$*"; }
fail() { printf '    \033[31mNG\033[0m    %s\n' "$*"; CHECK_FAILED=$((CHECK_FAILED + 1)); }
skip() { printf '    --    %s\n' "$*"; }

# 対話ログインシェルを起動し、コマンドの場所を 1 つ返す。プロンプトの表示などは捨てる
shell_which() {
  zsh -lic "print -r -- \"@@\$(command -v $1)\"" 2>/dev/null | sed -n 's/^@@//p' | tail -1
}

step_check() {
  log "リンク"
  local entry src dest
  for entry in "${LINKS[@]}"; do
    src="$DOTFILES/${entry%%|*}" dest="${entry#*|}"
    if [[ -L "$dest" && "$(readlink "$dest")" == "$src" && -e "$dest" ]]; then
      pass "$dest"
    else
      fail "$dest がリポジトリへのリンクになっていない"
    fi
  done

  log "zsh"
  if zsh -n "$DOTFILES/home/zshenv" "$DOTFILES/home/zprofile" "$DOTFILES/home/zshrc"; then
    pass "設定ファイルの文法"
  else
    fail "設定ファイルに文法エラーがある"
  fi
  local p
  p="$(shell_which node)";    [[ "$p" == "$HOME/.local/share/mise/"* ]] && pass "node は mise: $p"    || fail "node が mise ではない: ${p:-見つからない}"
  p="$(shell_which pnpm)";    [[ "$p" == "$HOME/Library/pnpm/"* ]]      && pass "pnpm は standalone 版: $p" || fail "pnpm が standalone 版ではない: ${p:-見つからない}"
  p="$(shell_which python3)"; [[ "$p" == "$HOME/.local/bin/"* ]]        && pass "python3 は uv: $p"    || fail "python3 が uv ではない: ${p:-見つからない}"

  log "git / GitHub CLI"
  [[ "$(git config --show-origin user.name 2>/dev/null)" == "file:$HOME/.config/git/config"* ]] \
    && pass "git が ~/.config/git/config を読んでいる" || fail "git が ~/.config/git/config を読んでいない"
  [[ ! -e "$HOME/.gitconfig" ]] \
    && pass "ホームに ~/.gitconfig がない（あると ~/.config/git/config より優先される）" || fail "ホームに ~/.gitconfig が残っている。中身を config/git/config に移して消す"
  # 一時的なリポジトリを作り、共通の無視設定が実際に効くかを試す
  local tmp
  tmp="$(mktemp -d)"
  git -C "$tmp" init -q && mkdir -p "$tmp/.claude" && touch "$tmp/.claude/settings.local.json"
  git -C "$tmp" check-ignore -q .claude/settings.local.json \
    && pass "共通の無視設定（~/.config/git/ignore）が効いている" || fail "共通の無視設定が効いていない"
  rm -rf "$tmp"
  if command -v gh >/dev/null; then
    [[ "$(gh config get git_protocol 2>/dev/null)" == "https" ]] && pass "gh の設定を読んでいる" || fail "gh の設定を読んでいない"
  else
    skip "gh が入っていない"
  fi

  log "mise / uv"
  if command -v mise >/dev/null; then
    mise config ls 2>/dev/null | grep -q '.config/mise/config.toml' && pass "mise が全体設定を読んでいる" || fail "mise が全体設定を読んでいない"
  else
    skip "mise が入っていない"
  fi
  if command -v uv >/dev/null; then
    p="$(uv python find 2>/dev/null)"
    [[ "$p" == "$HOME/.local/share/uv/python/"* ]] && pass "uv は自分で入れた Python を使う: $p" || fail "uv が Homebrew などの Python を使っている: ${p:-見つからない}"
  else
    skip "uv が入っていない"
  fi

  log "アプリ"
  local ghostty=/Applications/Ghostty.app/Contents/MacOS/ghostty
  if [[ -x "$ghostty" ]]; then
    "$ghostty" +validate-config >/dev/null 2>&1 && pass "Ghostty の設定にエラーがない" || fail "Ghostty の設定にエラーがある（ghostty +validate-config で確認）"
  else
    skip "Ghostty が入っていない"
  fi
  local kcli="/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli"
  if [[ -x "$kcli" ]]; then
    [[ -n "$("$kcli" --show-current-profile-name 2>/dev/null)" ]] && pass "Karabiner が設定を読んでいる" || fail "Karabiner が設定を読んでいない"
  else
    skip "Karabiner-Elements が入っていない"
  fi

  log "エディタ"
  local pair dir cli missing
  for pair in "vscode|code" "cursor|cursor"; do
    dir="${pair%%|*}" cli="${pair#*|}"
    if ! command -v "$cli" >/dev/null; then
      skip "$cli コマンドがない"
      continue
    fi
    missing="$(missing_extensions "$dir" "$cli" | tr '\n' ' ')"
    [[ -z "${missing// /}" ]] && pass "$dir の拡張機能がすべて入っている" || fail "$dir に入っていない拡張機能: ${missing}（./install.sh editor）"
  done

  log "セキュリティ"
  local fw=/usr/libexec/ApplicationFirewall/socketfilterfw
  fdesetup status 2>/dev/null | grep -q 'On' && pass "FileVault（ディスクの暗号化）が有効" || fail "FileVault が無効（システム設定 > プライバシーとセキュリティ）"
  "$fw" --getglobalstate 2>/dev/null | grep -q 'enabled' && pass "ファイアウォールが有効" || fail "ファイアウォールが無効（./install.sh security）"
  "$fw" --getstealthmode 2>/dev/null | grep -qE 'enabled|is on' && pass "ステルスモードが有効" || fail "ステルスモードが無効（./install.sh security）"
  grep -qE '^auth[[:space:]]+sufficient[[:space:]]+pam_tid\.so' /etc/pam.d/sudo_local 2>/dev/null \
    && pass "Touch ID で sudo が有効" || fail "Touch ID で sudo が無効（./install.sh security）"

  log "Homebrew"
  if command -v brew >/dev/null; then
    # 入っているかだけを見る。新しい版があるかどうかは問わない（更新は brew upgrade で別に行う）
    local kind name missing
    for kind in formula cask; do
      missing=""
      local installed
      installed=" $(brew list --"$kind" -1 2>/dev/null | tr '\n' ' ') "
      while read -r name; do
        [[ -z "$name" ]] && continue
        [[ "$installed" == *" ${name##*/} "* ]] || missing="$missing ${name}"
      done < <(grep -E "^${kind/formula/brew} \"" "$DOTFILES/Brewfile" | cut -d'"' -f2)
      if [[ -z "$missing" ]]; then
        pass "Brewfile の ${kind} はすべて入っている"
      else
        fail "入っていない ${kind}:${missing}"
      fi
    done
    skip "App Store アプリ（mas）は確認しない。mas の一覧取得が応答しないことがあるため"
  else
    skip "Homebrew が入っていない"
  fi

  if [[ $CHECK_FAILED -eq 0 ]]; then
    log "すべて問題なし"
  else
    warn "問題が ${CHECK_FAILED} 件あります"
    exit 1
  fi
}

main() {
  local steps=()
  for arg in "$@"; do
    case "$arg" in
      --dry-run) DRY_RUN=1 ;;
      -h|--help) sed -n '2,11p' "$0"; exit 0 ;;
      *) steps+=("$arg") ;;
    esac
  done
  [[ ${#steps[@]} -eq 0 ]] && steps=("${ALL_STEPS[@]}")

  # Homebrew が入っていれば、どのステップから実行しても brew・mise・uv などが使えるようにする。
  # 新しい Mac では、link を実行するまでシェルに Homebrew の PATH がないため
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  for s in "${steps[@]}"; do
    if ! declare -F "step_$s" >/dev/null; then
      warn "不明なステップ: ${s}（使えるもの: ${ALL_STEPS[*]} check）"
      exit 1
    fi
    "step_$s"
  done
  if [[ " ${steps[*]} " == *" check "* ]]; then
    return
  fi
  if [[ ${#FAILED_STEPS[@]} -gt 0 ]]; then
    warn "一部が失敗しました: ${FAILED_STEPS[*]}。表示されたエラーを確認し、そのステップだけ実行し直してください"
    exit 1
  fi
  log "完了。新しいターミナルを開くか exec zsh で反映してください"
}

main "$@"
