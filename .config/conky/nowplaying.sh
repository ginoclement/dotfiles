#!/usr/bin/env bash
#
# Now-playing helper for conky, backed by playerctl (MPRIS).
# Prefers Spotify, falls back to any player (e.g. media in the browser).
#
#   nowplaying.sh art     ensure album art is cached at ~/.cache/conky/albumart.png
#   nowplaying.sh title   print track title (truncated)
#   nowplaying.sh artist  print artist
#   nowplaying.sh album   print album
#   nowplaying.sh status  print ▶/⏸ marker
#
set -u

CACHE_DIR="$HOME/.cache/conky"
ART="$CACHE_DIR/albumart.png"
URL_FILE="$CACHE_DIR/arturl"
PLAYER="--player=spotify,%any"
MAXLEN=26

command -v playerctl >/dev/null 2>&1 || exit 0
mkdir -p "$CACHE_DIR"

status=$(playerctl $PLAYER status 2>/dev/null || true)
if [ -z "$status" ] || [ "$status" = "Stopped" ]; then
    # nothing playing: remove art so conky stops drawing it
    rm -f "$ART" "$URL_FILE"
    [ "${1:-}" = "title" ] && echo "nothing playing"
    exit 0
fi

meta() {
    playerctl $PLAYER metadata --format "{{$1}}" 2>/dev/null || true
}

trunc() {
    local s="$1"
    if [ "${#s}" -gt "$MAXLEN" ]; then
        printf '%s…\n' "${s:0:$((MAXLEN - 1))}"
    else
        printf '%s\n' "$s"
    fi
}

case "${1:-title}" in
    art)
        arturl=$(meta mpris:artUrl)
        [ -z "$arturl" ] && exit 0
        [ "$arturl" = "$(cat "$URL_FILE" 2>/dev/null)" ] && exit 0
        case "$arturl" in
            file://*) cp -f "${arturl#file://}" "$ART" ;;
            http*)    curl -sf --max-time 5 "$arturl" -o "$ART" ;;
        esac && printf '%s' "$arturl" > "$URL_FILE"
        ;;
    title)  trunc "$(meta xesam:title)" ;;
    artist) trunc "$(meta xesam:artist)" ;;
    album)  trunc "$(meta xesam:album)" ;;
    status)
        [ "$status" = "Playing" ] && echo "▶" || echo "⏸"
        ;;
esac
