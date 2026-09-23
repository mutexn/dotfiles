#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract info
used=$(echo "$input" | jq -r '.context_window.used_percentage // "0"')
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
model_name=$(echo "$input" | jq -r '.model.display_name // empty')

# Extract token usage info
total_in=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
total_out=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
total_tokens=$(( total_in + total_out ))

# Format total tokens as K (e.g. 12345 -> 12K)
if [ "$total_tokens" -ge 1000 ]; then
    tokens_display="$(( total_tokens / 1000 ))K"
else
    tokens_display="${total_tokens}"
fi

# Extract rate limit info (Claude.ai subscription only; empty if not available)
five_hour_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_hour_resets=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
seven_day_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
seven_day_resets=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

# Format seconds into human-readable duration (e.g. "1h5m", "12m30s")
format_duration() {
    local secs=$1
    if [ "$secs" -le 0 ]; then
        echo "now"
    elif [ "$secs" -ge 3600 ]; then
        local h=$(( secs / 3600 ))
        local m=$(( (secs % 3600) / 60 ))
        if [ "$m" -gt 0 ]; then
            echo "${h}h${m}m"
        else
            echo "${h}h"
        fi
    elif [ "$secs" -ge 60 ]; then
        local m=$(( secs / 60 ))
        local s=$(( secs % 60 ))
        if [ "$s" -gt 0 ]; then
            echo "${m}m${s}s"
        else
            echo "${m}m"
        fi
    else
        echo "${secs}s"
    fi
}

# Compute remaining time strings
five_hour_remaining=""
if [ -n "$five_hour_resets" ]; then
    now=$(date +%s)
    diff=$(( five_hour_resets - now ))
    five_hour_remaining=$(format_duration "$diff")
fi

seven_day_remaining=""
if [ -n "$seven_day_resets" ]; then
    now=$(date +%s)
    diff=$(( seven_day_resets - now ))
    seven_day_remaining=$(format_duration "$diff")
fi

# Get directory path with ~ for home directory
dir_path="${cwd/#$HOME/~}"

# Powerline separator characters
SEP=""  # Right-pointing arrow separator

# ANSI Color codes (note: these will appear dimmed in the status line)
# Format: \033[48;5;{color}m for background, \033[38;5;{color}m for foreground
RESET="\033[0m"

# Background colors
BG_BLUE="\033[48;5;33m"      # Bright blue for context
BG_GREEN="\033[48;5;28m"     # Green for clean git
BG_YELLOW="\033[48;5;136m"   # Yellow/orange for git changes
BG_PURPLE="\033[48;5;61m"    # Purple for directory
BG_RED="\033[48;5;124m"      # Red for no-git
BG_TEAL="\033[48;5;30m"      # Teal for token usage
BG_ORANGE="\033[48;5;166m"   # Orange for rate limit warning
BG_MODEL="\033[48;5;99m"     # Violet for model name

# Foreground colors for text
FG_WHITE="\033[38;5;231m"    # White text
FG_BLACK="\033[38;5;16m"     # Black text

# Foreground colors for separators (matching previous segment background)
FG_BLUE="\033[38;5;33m"
FG_GREEN="\033[38;5;28m"
FG_YELLOW="\033[38;5;136m"
FG_PURPLE="\033[38;5;61m"
FG_RED="\033[38;5;124m"
FG_TEAL="\033[38;5;30m"
FG_ORANGE="\033[38;5;166m"
FG_MODEL="\033[38;5;99m"

# Nerd Font icons
ICON_CONTEXT="󰾆"  # Brain/memory icon for context
ICON_GIT=""      # Git branch icon
ICON_FOLDER=""    # Folder icon
ICON_TOKEN="󰐅"   # Token/usage icon
ICON_RATE=""     # Rate limit / speed icon
ICON_MODEL="󰚩"    # Model / AI icon

# Git information
git_branch=""
git_changes=""
git_bg=""
git_sep_color=""

if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    # Get branch name
    git_branch=$(git -C "$cwd" branch --show-current 2>/dev/null || echo "detached")

    # Get git status (skip optional locks to avoid conflicts)
    git_status=$(git -C "$cwd" -c core.fileMode=false status --porcelain --no-optional-locks 2>/dev/null)

    # Count changes
    if [ -n "$git_status" ]; then
        modified=$(echo "$git_status" | grep -c "^ M" || echo "0")
        added=$(echo "$git_status" | grep -c "^A\|^??" || echo "0")
        deleted=$(echo "$git_status" | grep -c "^ D" || echo "0")

        changes_text=""
        [ "$modified" != "0" ] && changes_text="${changes_text}~${modified}"
        [ "$added" != "0" ] && changes_text="${changes_text}+${added}"
        [ "$deleted" != "0" ] && changes_text="${changes_text}-${deleted}"

        if [ -n "$changes_text" ]; then
            git_changes=" ${changes_text}"
        fi

        # Use yellow/orange background if there are changes
        git_bg="$BG_YELLOW"
        git_sep_color="$FG_YELLOW"
    else
        # Use green background if clean
        git_bg="$BG_GREEN"
        git_sep_color="$FG_GREEN"
    fi
else
    git_branch="no-git"
    git_bg="$BG_RED"
    git_sep_color="$FG_RED"
fi

# Determine which optional segments will be shown (needed to decide
# whether a trailing segment should omit its powerline arrow)
show_tokens=false
[ "$total_tokens" -gt 0 ] && show_tokens=true

show_rate=false
if [ -n "$five_hour_pct" ] || [ -n "$seven_day_pct" ]; then
    show_rate=true
fi

# Build Powerline-styled status line using printf

# --- First line: git status + current directory ---
printf "${git_bg}${FG_WHITE} ${ICON_GIT} ${git_branch}${git_changes} ${RESET}${git_sep_color}${SEP}${RESET}"
printf "${BG_PURPLE}${FG_WHITE} ${ICON_FOLDER} ${dir_path} ${RESET}\n"

# --- Second line: model / context usage / token usage / rate limits ---

# Model segment (only shown when model display name is available)
if [ -n "$model_name" ]; then
    printf "${BG_MODEL}${FG_WHITE} ${ICON_MODEL} %s ${RESET}${FG_MODEL}${SEP}${RESET}" "$model_name"
fi

# Context usage segment (arrow only if a later segment will follow)
if [ "$show_tokens" = true ] || [ "$show_rate" = true ]; then
    printf "${BG_BLUE}${FG_WHITE} ${ICON_CONTEXT} %.0f%% ${RESET}${FG_BLUE}${SEP}${RESET}" "$used"
else
    printf "${BG_BLUE}${FG_WHITE} ${ICON_CONTEXT} %.0f%% ${RESET}" "$used"
fi

# Token usage segment (only show if any tokens have been used)
if [ "$show_tokens" = true ]; then
    if [ "$show_rate" = true ]; then
        printf "${BG_TEAL}${FG_WHITE} ${ICON_TOKEN} %s ${RESET}${FG_TEAL}${SEP}${RESET}" "$tokens_display"
    else
        printf "${BG_TEAL}${FG_WHITE} ${ICON_TOKEN} %s ${RESET}" "$tokens_display"
    fi
fi

# Rate limit segment (only shown for Claude.ai subscribers after first API response)
# Compact form: only used percentages, no remaining-time parentheses
if [ "$show_rate" = true ]; then
    rate_text=""
    if [ -n "$five_hour_pct" ]; then
        rate_text="${rate_text}5h:$(printf '%.0f' "$five_hour_pct")%"
        if [ -n "$five_hour_resets" ]; then
            rate_text="${rate_text} (→$(date -r "$five_hour_resets" "+%H:%M"))"
        fi
    fi
    if [ -n "$seven_day_pct" ]; then
        [ -n "$rate_text" ] && rate_text="${rate_text} "
        rate_text="${rate_text}7d:$(printf '%.0f' "$seven_day_pct")%"
        if [ -n "$seven_day_resets" ]; then
            rate_text="${rate_text} (→$(date -r "$seven_day_resets" "+%-m/%-d %H:%M"))"
        fi
    fi
    printf "${BG_ORANGE}${FG_WHITE} ${ICON_RATE} %s ${RESET}" "$rate_text"
fi

echo ""
