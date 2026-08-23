# dotfiles

Dotfiles for Manjaro: zsh + starship + tmux + neovim + kitty + rofi + conky,
with a docker-heavy alias set.

## Install

```bash
git clone git@github.com:ginoclement/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh --packages
```

`install.sh` symlinks everything into `$HOME` (existing files are backed up to
`~/.dotfiles-backup-<timestamp>/`) and sets zsh as the default shell. The
`--packages` flag installs everything needed via pacman:

zsh, zsh-autosuggestions, zsh-syntax-highlighting, zsh-completions, tmux,
neovim, git, starship, fzf, zoxide, bat, eza, ripgrep, fd, rofi-wayland,
rofi-calc, kitty, conky, ttf-jetbrains-mono-nerd, lazygit, lazydocker,
git-delta, btop, jq, yq, tealdeer

From the AUR (via `pamac build`), not handled by the script: `vscodium-bin`
(the settings.json here is linked into place for it), `spicetify-cli` for
Spotify theming.

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
| `.config/rofi/` | Launcher config + dark minimal theme (`config.rasi`, `gino-dark.rasi`) and `powermenu.sh` |
| `.config/kitty/kitty.conf` | Terminal themed to match gino-dark, JetBrains Mono Nerd Font, cwd-preserving tabs |
| `.config/conky/conky.conf` | Desktop stats: clock, CPU/mem/disk, network, running docker containers |
| `.config/autostart/conky.desktop` | Starts conky on login |
| `.config/VSCodium/User/settings.json` | VSCodium defaults: Nerd Font, zsh terminal, 2-space yaml/json |
| `.gitconfig` | User info plus sane modern defaults (`push.autoSetupRemote`, `fetch.prune`, zdiff3 conflicts) |

## Cheat sheet

**tmux** (prefix is `Ctrl-Space`)

- `t` — attach to (or create) the `main` session
- `prefix |` / `prefix -` — split right / down (keeps current directory)
- `Alt+arrows` — move between panes, no prefix needed
- `Shift+Left/Right` — previous/next window
- `prefix r` — reload config, `prefix I` — install/update plugins
- `prefix g` — lazygit popup, `prefix D` — lazydocker popup (in current dir)
- Sessions auto-save and restore across reboots (continuum)

**shell**

- `Ctrl-R` — fuzzy history search, `Ctrl-T` — fuzzy file search, `Alt-C` — fuzzy cd
- `z <partial-dir>` — jump to a frequently used directory (zoxide)
- `dcu` / `dcd` / `dcl` — compose up/down/logs; `dps` — readable `docker ps`
- `lg` — lazygit, `lzd` — lazydocker; `git diff` output is rendered by delta
- `tldr <cmd>` — quick usage examples; `btop` — system monitor
- `pacu` — full system update

**rofi**

Modes: Apps, Run, Windows, SSH (hosts from `~/.ssh/config`), Calc. Switch
modes inside rofi with `Ctrl+Tab`.

Bind the keys yourself in System Settings → Shortcuts → Add New → Command
(KDE), or your WM config:

- `rofi -show drun` — app launcher (suggested: `Meta+Space`)
- `rofi -show window` — window switcher (suggested: `Meta+Tab`)
- `~/.config/rofi/powermenu.sh` — lock/logout/suspend/reboot/shutdown
  (suggested: `Meta+Escape`)

The `rofi-wayland` package runs on both KDE Wayland and X11 sessions. Check
which you're on with `echo $XDG_SESSION_TYPE`. The calculator mode
(`rofi -show calc`) needs `rofi-calc`, installed by `install.sh --packages`.
