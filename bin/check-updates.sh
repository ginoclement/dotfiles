#!/usr/bin/env bash
#
# Checks whether the dotfiles repo has commits upstream that aren't local
# yet, and writes the result to a status file that .zshrc reads on startup.
#
# Called two ways, both of which avoid ever blocking a shell on the
# network: an hourly systemd --user timer (dotfiles-check-update.timer)
# runs this unconditionally, and .zshrc also backgrounds it once per new
# terminal window as a best-effort top-up. $CHECK_INTERVAL below is just a
# short debounce so two near-simultaneous triggers (e.g. two terminals
# opened at once) don't both hit the network — it is NOT what controls the
# hourly cadence; the systemd timer does that.
#
# The actual check is two-stage for speed: `git ls-remote` is a single
# stateless round-trip that returns the branch's current SHA with no
# object transfer, so the common case (nothing changed) is nearly free.
# Only when the SHA has actually moved do we do a real `git fetch`, to get
# an accurate "N commits behind" count for the prompt.
#
set -uo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
STATE_DIR="$HOME/.cache/dotfiles"
STATUS_FILE="$STATE_DIR/update-status"
STAMP_FILE="$STATE_DIR/last-check"
CHECK_INTERVAL=$((5 * 60))  # debounce only, see note above

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
local_sha=$(git rev-parse HEAD 2>/dev/null) || exit 0
remote_sha=$(timeout 5 git ls-remote origin "refs/heads/$branch" 2>/dev/null | cut -f1)

if [ -z "$remote_sha" ]; then
    exit 0  # network/auth failure — leave the existing cached status alone
fi

if [ "$remote_sha" = "$local_sha" ]; then
    echo "current" > "$STATUS_FILE"
    exit 0
fi

# SHA moved: fetch (still quiet/bounded) to get a real commit count
timeout 5 git fetch --quiet origin "$branch" 2>/dev/null || exit 0
behind=$(git rev-list --count "HEAD..origin/$branch" 2>/dev/null || echo 0)

if [ "${behind:-0}" -gt 0 ]; then
    echo "behind:$behind:$branch" > "$STATUS_FILE"
else
    echo "current" > "$STATUS_FILE"
fi
