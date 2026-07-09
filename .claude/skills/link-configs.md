---
name: link-configs
description: Link or re-link dotfile configs into the home directory using GNU Stow
user_invocable: true
---

# Link Configs

Create or refresh symlinks from this dotfiles repo into `$HOME` using GNU Stow.

## Steps

1. **Check stow is installed**:
   ```bash
   command -v stow || brew install stow
   ```

2. **Link all packages**:
   ```bash
   cd /path/to/dotfiles
   stow -v -t "$HOME" zsh
   stow -v -t "$HOME" tmux
   stow -v -t "$HOME" git
   ```

3. **Link nvim** (submodule, handled separately):
   ```bash
   mkdir -p ~/.config
   ln -sf "$(pwd)/nvim" ~/.config/nvim
   ```

4. **Verify links**:
   ```bash
   ls -la ~/.zshrc ~/.tmux.conf ~/.gitconfig ~/.config/nvim
   ```
   Each should be a symlink pointing back into this repo.

## Unlinking

To remove symlinks for a package without deleting config files:
```bash
stow -D -t "$HOME" tmux
```

## Adding a new stow package

1. Create a directory: `mkdir -p newpkg/.config/newpkg`
2. Add config files mirroring the home directory structure
3. Run `stow -v -t "$HOME" newpkg`
4. Add the stow command to `bootstrap.sh`

## Conflict resolution

If stow reports "existing target is not a symlink", the file already exists in `$HOME` and isn't managed by stow. Either:
- Back it up: `mv ~/.somefile ~/.somefile.bak`
- Or adopt it into stow: `stow --adopt -t "$HOME" package` (overwrites repo copy with existing file — use carefully)
