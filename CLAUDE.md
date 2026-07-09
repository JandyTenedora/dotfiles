# Dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/) and git submodules.

## Structure

```
dotfiles/
├── tmux/           # stow package: .tmux.conf + .tmux/ (TPM as submodule)
├── zsh/            # stow package: .zshrc
├── git/            # stow package: .gitconfig
├── claude/         # stow package: ~/.claude/CLAUDE.md (global Claude Code instructions)
├── nvim/           # stow package: ~/.config/nvim (init.lua, lua/plugins/, lazy-lock.json)
├── aerospace/      # stow package: ~/.config/aerospace/aerospace.toml (tiling WM)
├── Brewfile        # declarative brew dependencies
├── bootstrap.sh    # full machine setup script
└── .claude/skills/ # Claude Code skills for setup tasks
```

## How stow works

Each top-level directory (tmux/, zsh/, git/) is a "stow package". Running `stow -t ~ tmux` creates symlinks in `$HOME` mirroring the package's internal structure. For example:
- `tmux/.tmux.conf` -> `~/.tmux.conf`
- `tmux/.tmux/` -> `~/.tmux/`

## Git submodules

- `tmux/.tmux/plugins/tpm/` — Tmux Plugin Manager

After cloning, run `git submodule update --init --recursive` to pull them.

## Adding a new config

1. Create a directory named after the tool (e.g., `alacritty/`)
2. Mirror the home directory structure inside it (e.g., `alacritty/.config/alacritty/alacritty.toml`)
3. Run `stow -v -t ~ alacritty` to link it
4. Add the stow command to `bootstrap.sh`

## Key commands

```bash
./bootstrap.sh              # Full setup on a new machine
brew bundle --file=Brewfile  # Install/update brew packages only
stow -v -t ~ tmux           # Re-link a single package
stow -D -t ~ tmux           # Unlink a package
```
