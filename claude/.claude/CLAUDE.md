# Global user instructions

## Editing config or dotfiles

Before editing any config file or dotfile in `$HOME` (e.g. `~/.tmux.conf`, `~/.zshrc`, `~/.gitconfig`, `~/.config/<tool>/...`), **check whether it is a symlink into a version-controlled repo first** — most of mine are managed by GNU Stow out of `~/src/dotfiles/`.

Rules:
1. Run `readlink` (or `ls -la`) on the target path. If it's a symlink, follow it to the source.
2. Edit the file at the source path inside the repo, not the symlink in `$HOME`. This keeps the change tracked in git and survives a re-stow.
3. If the source repo has uncommitted changes you didn't make, surface them before adding more — don't silently bundle unrelated diffs.
4. After editing, mention that the change is in the repo and offer to commit it.

This applies even when I ask in casual terms like "edit my tmux config" — assume the source-of-truth is the repo unless I say otherwise.
