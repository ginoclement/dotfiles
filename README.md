# dotfiles

Dotfiles for Manjaro: zsh + starship + tmux + neovim, with a docker-heavy alias set.

## Install

```bash
git clone git@github.com:ginoclement/bash_settings.git ~/dotfiles
cd ~/dotfiles
./install.sh --packages
```

`install.sh` symlinks everything into `$HOME` (existing files are backed up to
`~/.dotfiles-backup-<timestamp>/`) and sets zsh as the default shell. The
`--packages` flag installs everything needed via pacman:

zsh, zsh-autosuggestions, zsh-syntax-highlighting, zsh-completions, tmux,
neovim, git, starship, fzf, zoxide, bat, eza, ripgrep, fd

Since the files are symlinks, editing them in the repo takes effect immediately —
commit and push to sync changes.

## What's inside

| File | Purpose |
|---|---|
| `.zshrc` | zsh with shared history, case-insensitive completion, autosuggestions + syntax highlighting (from pacman), fzf keybindings, zoxide, starship |
| `.aliases` | git shortcuts, docker/compose shortcuts, pacman helpers, eza/bat replacements for ls/cat |
| `.tmux.conf` | Ctrl-Space prefix, mouse support, TPM with resurrect + continuum (sessions survive reboots) |
| `.config/starship.toml` | Minimal prompt: `dir [branch]$` — cyan branch, magenta when dirty |
| `.config/nvim/init.lua` | Neovim config carried over from the old `.vimrc`, plugin-free |
| `.gitconfig` | User info plus sane modern defaults (`push.autoSetupRemote`, `fetch.prune`, zdiff3 conflicts) |

## Cheat sheet

**tmux** (prefix is `Ctrl-Space`)

- `t` — attach to (or create) the `main` session
- `prefix |` / `prefix -` — split right / down (keeps current directory)
- `Alt+arrows` — move between panes, no prefix needed
- `Shift+Left/Right` — previous/next window
- `prefix r` — reload config, `prefix I` — install/update plugins
- Sessions auto-save and restore across reboots (continuum)

**shell**

- `Ctrl-R` — fuzzy history search, `Ctrl-T` — fuzzy file search, `Alt-C` — fuzzy cd
- `z <partial-dir>` — jump to a frequently used directory (zoxide)
- `dcu` / `dcd` / `dcl` — compose up/down/logs; `dps` — readable `docker ps`
- `pacu` — full system update
