---
name: install-brew
description: Install or update Homebrew packages from the Brewfile
user_invocable: true
---

# Install Brew Packages

Install or update all packages defined in the Brewfile.

## Steps

1. **Check Homebrew is installed**:
   ```bash
   command -v brew || echo "Homebrew not installed — run ./bootstrap.sh first"
   ```

2. **Install/update packages**:
   ```bash
   brew bundle --file=Brewfile
   ```

3. **Check for packages not in Brewfile** (optional cleanup):
   ```bash
   brew bundle cleanup --file=Brewfile
   ```
   This lists packages installed via brew that aren't in the Brewfile. Ask the user if they want to add them to the Brewfile or uninstall them.

4. **Adding a new package**: When the user asks to add a package:
   - Add the line to `Brewfile` (use `brew "name"` for formulae, `cask "name"` for GUI apps)
   - Run `brew bundle --file=Brewfile` to install it
   - Commit the Brewfile change

## Brewfile format

```ruby
tap "homebrew/bundle"    # Tap a third-party repo
brew "ripgrep"           # CLI formula
cask "iterm2"            # GUI application
```
