---
name: setup-machine
description: Set up a brand new macOS machine with all tools, configs, and apps
user_invocable: true
---

# Setup Machine

Full setup for a new macOS machine. Run this from inside the dotfiles repo.

## Steps

1. **Verify prerequisites**: Check if Xcode Command Line Tools are installed. If not, run:
   ```bash
   xcode-select --install
   ```

2. **Run bootstrap**: Execute `./bootstrap.sh` which handles:
   - Installing Homebrew (if missing)
   - Installing all Brewfile packages (CLI tools, languages, casks like iTerm2)
   - Installing Oh My Zsh (if missing)
   - Initializing git submodules (nvim config, TPM)
   - Stowing dotfiles (zsh, tmux, git)
   - Symlinking nvim config to `~/.config/nvim`
   - Installing tmux plugins via TPM

3. **Post-bootstrap manual steps** (remind the user):
   - Open iTerm2 and set it as default terminal
   - In iTerm2 preferences, set the font to "JetBrainsMono Nerd Font"
   - Open tmux and press `prefix+I` (Ctrl-a then I) to install tmux plugins
   - Open nvim and let lazy.nvim auto-install plugins
   - Run `git lfs install` if using git-lfs
   - Authenticate with GitHub: `gh auth login`
   - Set up gcloud: `gcloud auth login`

4. **Verify**: Open a new terminal and check:
   ```bash
   which brew && which nvim && which tmux && which stow
   ls -la ~/.zshrc ~/.tmux.conf ~/.gitconfig ~/.config/nvim
   ```

## Troubleshooting

- If stow complains about conflicts, the bootstrap script backs up existing files to `*.bak`
- If nvim plugins fail, run `:Lazy sync` inside nvim
- If tmux plugins fail, press `prefix+I` inside tmux
