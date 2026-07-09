---
name: add-config
description: Add a new tool's config to the dotfiles repo as a stow package
user_invocable: true
---

# Add Config

Add a new tool's configuration to this dotfiles repo.

## Steps

1. **Determine where the config lives** in the home directory. Common patterns:
   - `~/.toolrc` (e.g., `.bashrc`, `.zshrc`)
   - `~/.config/tool/` (XDG standard, e.g., `~/.config/alacritty/`)
   - `~/.tool/` (e.g., `~/.ssh/`)

2. **Create the stow package** mirroring that structure:
   ```bash
   # For ~/.toolrc
   mkdir -p toolname
   cp ~/.toolrc toolname/.toolrc

   # For ~/.config/tool/
   mkdir -p toolname/.config/tool
   cp ~/.config/tool/* toolname/.config/tool/
   ```

3. **Back up and link**:
   ```bash
   mv ~/.toolrc ~/.toolrc.bak  # if needed
   stow -v -t "$HOME" toolname
   ```

4. **Update bootstrap.sh**: Add `stow -v -t "$HOME" toolname` to the stow section.

5. **Update CLAUDE.md**: Add the new package to the structure diagram.

6. **Commit**:
   ```bash
   git add toolname/ bootstrap.sh CLAUDE.md
   git commit -m "feat: add toolname config"
   ```

## If it's an existing git repo

Add it as a submodule instead and handle the symlink in bootstrap.sh (like nvim):
```bash
git submodule add <url> toolname
# Then add symlink logic to bootstrap.sh
```
