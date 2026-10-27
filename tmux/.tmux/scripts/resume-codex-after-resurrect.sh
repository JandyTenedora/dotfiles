#!/usr/bin/env bash

set -u

tmux_bin="${TMUX_BIN:-tmux}"

resurrect_file() {
    if [ -n "${TMUX_RESURRECT_FILE:-}" ]; then
        printf '%s\n' "$TMUX_RESURRECT_FILE"
        return
    fi

    local resurrect_dir
    resurrect_dir="$("$tmux_bin" show-option -gqv @resurrect-dir 2>/dev/null)"

    if [ -z "$resurrect_dir" ]; then
        if [ -d "$HOME/.tmux/resurrect" ]; then
            resurrect_dir="$HOME/.tmux/resurrect"
        else
            resurrect_dir="${XDG_DATA_HOME:-$HOME/.local/share}/tmux/resurrect"
        fi
    else
        resurrect_dir="${resurrect_dir//\$HOME/$HOME}"
        resurrect_dir="${resurrect_dir//\$HOSTNAME/$(hostname)}"
        resurrect_dir="${resurrect_dir/#\~/$HOME}"
    fi

    printf '%s/last\n' "$resurrect_dir"
}

quote_for_shell() {
    printf "'"
    printf '%s' "$1" | sed "s/'/'\\\\''/g"
    printf "'"
}

state_file="$(resurrect_file)"
[ -f "$state_file" ] || exit 0

default_shell="$("$tmux_bin" show-option -gqv default-shell 2>/dev/null)"
default_shell="${default_shell##*/}"
[ -n "$default_shell" ] || default_shell="${SHELL:-sh}"
default_shell="${default_shell##*/}"

while IFS=$'\t' read -r record_type session_name window_index _window_active \
    _window_flags pane_index _pane_title _pane_dir _pane_active pane_command \
    _pane_full_command; do
    [ "$record_type" = "pane" ] || continue
    [ "$pane_command" = "codex" ] || continue

    target="${session_name}:${window_index}.${pane_index}"
    current_command="$("$tmux_bin" display-message -p -t "$target" -F '#{pane_current_command}' 2>/dev/null)" || continue
    [ "$current_command" = "$default_shell" ] || continue

    window_name="$("$tmux_bin" display-message -p -t "$target" -F '#{window_name}' 2>/dev/null)" || continue
    [ -n "$window_name" ] || continue
    if printf '%s' "$window_name" | LC_ALL=C grep -q '[[:cntrl:]]'; then
        continue
    fi

    command="codex resume -- $(quote_for_shell "$window_name")"
    "$tmux_bin" send-keys -l -t "$target" "$command" &&
        "$tmux_bin" send-keys -t "$target" Enter
done < "$state_file"
