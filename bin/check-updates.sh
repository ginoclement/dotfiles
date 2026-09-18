#!/usr/bin/env bash
#
# Checks whether the dotfiles repo has commits upstream that aren't local
# yet, and writes the result to a status file that .zshrc reads on startup.
#
# Deliberately NOT called synchronously from the shell prompt: a `git
# fetch` over the network would add lag (or hang) to every single new
# terminal. Instead .zshrc backgrounds this script and only ever reads the
# cached result, and this script rate-limits itself so it hits the network
# at most once per $CHECK_INTERVAL regardless of how many terminals you open.
#
set -uo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
STATE_DIR="$HOME/.cache/dotfiles"
STATUS_FILE="$STATE_DIR/update-status"
STAMP_FILE="$STATE_DIR/last-check"
CHECK_INTERVAL=$((4 * 60 * 60))  # seconds between network checks

mkdir -p "$STATE_DIR"
[ -d "$DOTFILES_DIR/.git" ] || exit 0

if [ -f "$STAMP_FILE" ]; then
    last=$(stat -c %Y "$STAMP_FILE" 2>/dev/null || echo 0)
    now=$(date +%s)
    if (( now - last < CHECK_INTERVAL )); then
        exit 0
    fi
fi
touch "$STAMP_FILE"

cd "$DOTFILES_DIR" || exit 0
branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null) || exit 0
timeout 5 git fetch --quiet origin "$branch" 2>/dev/null || exit 0

behind=$(git rev-list --count "HEAD..origin/$branch" 2>/dev/null || echo 0)

if [ "${behind:-0}" -gt 0 ]; then
    echo "behind:$behind:$branch" > "$STATUS_FILE"
else
    echo "current" > "$STATUS_FILE"
fi
