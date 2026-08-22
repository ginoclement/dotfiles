#!/usr/bin/env bash
#
# Rofi power menu: lock / logout / suspend / reboot / shutdown.
# Bind a key (e.g. Meta+Escape) to run this script.
#
set -euo pipefail

menu() {
    rofi -dmenu -p "$1" -i \
        -theme gino-dark \
        -theme-str 'window {width: 260px;} listview {lines: 5;} inputbar {enabled: false;}'
}

confirm() {
    local answer
    answer=$(printf 'No\nYes' | rofi -dmenu -p "$1 — sure?" -i \
        -theme gino-dark \
        -theme-str 'window {width: 260px;} listview {lines: 2;} inputbar {enabled: false;}')
    [ "$answer" = "Yes" ]
}

choice=$(printf 'Lock\nLogout\nSuspend\nReboot\nShutdown' | menu "Power") || exit 0

case "$choice" in
    Lock)
        loginctl lock-session
        ;;
    Logout)
        # KDE has a proper logout call; fall back to killing the session
        if command -v qdbus >/dev/null 2>&1 && qdbus org.kde.Shutdown >/dev/null 2>&1; then
            qdbus org.kde.Shutdown /Shutdown org.kde.Shutdown.logout
        else
            loginctl terminate-session "${XDG_SESSION_ID:-}"
        fi
        ;;
    Suspend)
        systemctl suspend
        ;;
    Reboot)
        confirm "Reboot" && systemctl reboot
        ;;
    Shutdown)
        confirm "Shutdown" && systemctl poweroff
        ;;
esac
