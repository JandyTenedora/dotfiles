#!/usr/bin/env bash
set -euo pipefail

PERSONAL="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK="$HOME/Documents/SpotifyGHE/dotfiles"

if [ ! -d "$WORK" ]; then
    echo "Error: work dotfiles not found at $WORK"
    exit 1
fi

echo "==> Syncing portable configs from work repo..."

# Configs that copy as-is (no Spotify content)
for pkg in nvim tmux starship aerospace p10k btop lazygit k9s; do
    echo "    $pkg"
    rsync -a --delete \
        --exclude '.git' \
        --exclude 'plugins/tpm/' \
        --exclude 'plugins/tmux-resurrect/' \
        --exclude 'plugins/tmux-continuum/' \
        "$WORK/$pkg/" "$PERSONAL/$pkg/"
done

echo ""
echo "==> Done. Review changes with 'git diff', then commit what looks good."
echo ""
echo "NOTE: zsh, git, Brewfile, and bootstrap.sh are NOT synced automatically"
echo "      because they contain Spotify-specific content that was manually"
echo "      stripped. Update those by hand if needed."
