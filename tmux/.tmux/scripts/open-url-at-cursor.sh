#!/usr/bin/env bash
#
# Open the URL under the mouse cursor in Google Chrome.
#
# Used by the DoubleClick1Pane binding in .tmux.conf. tmux fills in
# #{mouse_hyperlink} when the double-clicked text is a real terminal hyperlink
# (OSC 8); otherwise the URL is recovered from the pane content at the click
# position. When the click is not on a URL the script reproduces tmux's default
# double-click behaviour (select word, copy to buffer).
#
# Usage: open-url-at-cursor.sh <pane_id> <mouse_x> <mouse_y> [hyperlink]
#   DRY_RUN=1  resolve the URL and print it instead of opening a browser

set -u

pane=${1:-}
x=${2:-}
y=${3:-}
hyperlink=${4:-}

open_url() {
  if [ "${DRY_RUN:-}" = "1" ]; then
    printf 'OPEN: %s\n' "$1"
    return 0
  fi
  open -a "Google Chrome" "$1" 2>/dev/null || open "$1"
}

case "$hyperlink" in
  http://* | https://*)
    open_url "$hyperlink"
    exit 0
    ;;
esac

if [ -z "$pane" ] || [ -z "$x" ] || [ -z "$y" ]; then
  exit 0
fi

line=$(tmux capture-pane -p -t "$pane" 2>/dev/null | sed -n "${y}p")

url=$(
  URL_LINE="$line" URL_COL="$x" python3 - <<'PY'
import os
import re

line = os.environ.get("URL_LINE", "")
try:
    col = int(os.environ.get("URL_COL", "0"))
except ValueError:
    col = 0

for match in re.finditer(r"https?://[^\s'\"<>]+", line):
    # mouse_x is 1-based; treat the click as hitting the URL if it lands on or
    # immediately after any character of it.
    if match.start() <= col - 1 < match.end():
        url = match.group(0).rstrip(".,;:!?")
        while url.endswith(")") and url.count(")") > url.count("("):
            url = url[:-1]
        print(url)
        break
PY
)

if [ -n "$url" ]; then
  open_url "$url"
  exit 0
fi

tmux copy-mode -H -t "$pane" 2>/dev/null
tmux send-keys -X -t "$pane" select-word 2>/dev/null
sleep 0.15
tmux send-keys -X -t "$pane" copy-pipe-and-cancel 2>/dev/null
exit 0
