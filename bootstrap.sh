#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Dotfiles directory: $DOTFILES_DIR"

# --- Homebrew ---
if ! command -v brew &>/dev/null; then
    echo "==> Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "==> Homebrew already installed"
fi

# --- Brew bundle ---
echo "==> Installing Homebrew packages from Brewfile..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

# --- Oh My Zsh ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "==> Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "==> Oh My Zsh already installed"
fi

# --- Git submodules (tpm) ---
echo "==> Initializing git submodules..."
cd "$DOTFILES_DIR"
git submodule update --init --recursive

# --- GNU Stow ---
echo "==> Linking dotfiles with stow..."

# Remove existing files that would conflict with stow symlinks
for target in "$HOME/.zshrc" "$HOME/.tmux.conf" "$HOME/.gitconfig" "$HOME/.p10k.zsh"; do
    if [ -f "$target" ] && [ ! -L "$target" ]; then
        echo "    Backing up $target -> ${target}.bak"
        mv "$target" "${target}.bak"
    fi
done

# Remove existing .tmux directory if it's not a symlink (stow needs to own it)
if [ -d "$HOME/.tmux" ] && [ ! -L "$HOME/.tmux" ]; then
    echo "    Backing up ~/.tmux -> ~/.tmux.bak"
    mv "$HOME/.tmux" "$HOME/.tmux.bak"
fi

cd "$DOTFILES_DIR"
stow -v -t "$HOME" zsh
stow -v -t "$HOME" tmux
stow -v -t "$HOME" git
stow -v -t "$HOME" aerospace
stow -v -t "$HOME" starship
stow -v -t "$HOME" btop
stow -v -t "$HOME" k9s
stow -v -t "$HOME" lazygit
stow -v -t "$HOME" p10k

# --- Neovim (submodule, symlinked separately) ---
echo "==> Linking Neovim config..."
mkdir -p "$HOME/.config"
if [ -L "$HOME/.config/nvim" ]; then
    rm "$HOME/.config/nvim"
elif [ -d "$HOME/.config/nvim" ]; then
    echo "    Backing up ~/.config/nvim -> ~/.config/nvim.bak"
    mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak"
fi
ln -sf "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

# --- TPM plugins ---
echo "==> Installing tmux plugins..."
if [ -x "$HOME/.tmux/plugins/tpm/bin/install_plugins" ]; then
    "$HOME/.tmux/plugins/tpm/bin/install_plugins"
else
    echo "    TPM install_plugins not found, run prefix+I in tmux to install plugins"
fi

echo ""
echo "==> Done! Open a new terminal to pick up changes."
echo "    - Restart tmux and press prefix+I to install tmux plugins"
echo "    - Open nvim and let lazy.nvim install plugins automatically"
