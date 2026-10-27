#!/usr/bin/env bash
set -euo pipefail

PERSONAL="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK="${WORK_DOTFILES:-$HOME/src/dotfiles}"

if [ ! -d "$WORK" ]; then
    echo "Error: work dotfiles not found at $WORK (override with WORK_DOTFILES=/path)"
    exit 1
fi

echo "==> Syncing portable configs from work repo ($WORK)..."

# Packages where the work repo is the source of truth and copy as-is.
# nvim is deliberately NOT in this list: it diverged in both directions (personal
# carries lspsaga plus extra LSP/JDTLS/telescope keymaps that the work repo does
# not have, and --delete would remove them). Merge nvim by hand.
for pkg in tmux starship aerospace p10k btop lazygit k9s; do
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
echo "NOTE: nvim is not synced automatically - it has personal-only changes that"
echo "      rsync --delete would destroy. Merge it by hand."
echo "NOTE: zsh, git, Brewfile, and bootstrap.sh are NOT synced automatically"
echo "      because they contain work-specific content that was manually"
echo "      stripped. Update those by hand if needed."
