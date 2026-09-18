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
git-delta, btop, jq, yq, tealdeer, playerctl

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
| `.config/conky/conky.conf` | Desktop stats: clock, CPU/mem/disk, network, docker containers, battery, now playing with album art |
| `.config/conky/nowplaying.sh` | Fetches track metadata + album art from Spotify/any MPRIS player via playerctl |
| `.config/autostart/conky.desktop` | Starts conky on login |
| `.config/VSCodium/User/settings.json` | VSCodium defaults: Nerd Font, zsh terminal, 2-space yaml/json |
| `.gitconfig` | User info plus sane modern defaults (`push.autoSetupRemote`, `fetch.prune`, zdiff3 conflicts) |

## Cheat sheet

**tmux** (prefix is `Ctrl-Space`)

Every new terminal window auto-attaches to a session named `main` (set up
in `.zshrc`) — you're always inside tmux, no need to type `tmux` yourself.
Opening a second terminal window attaches to that *same* session rather
than starting a separate one — see "one session vs many" below before you
get confused by two windows showing identical content.

- `prefix |` / `prefix -` — split right / down (keeps current directory)
- `Alt+arrows` — move between panes, no prefix needed
- `Shift+Left/Right` — previous/next window
- `prefix c` — new window; `prefix ,` — rename the current window
- `prefix d` — detach (the session keeps running in the background)
- `prefix z` — zoom the current pane to fullscreen, press again to unzoom
- `prefix [` — enter copy/scroll mode (vi-style: `hjkl` to move, `/` to
  search, `v` to start a selection, `y` to copy, `q` to exit)
- `prefix r` — reload config, `prefix I` — install/update plugins
- `prefix g` — lazygit popup, `prefix D` — lazydocker popup (in current dir)
- `prefix ?` — list every keybinding currently active
- Sessions auto-save and restore across reboots (continuum) — so a reboot
  or accidental tmux crash doesn't lose your panes and running commands

**One session vs many.** `main` is one shared workspace: every terminal
window is a *client* looking at the same session, so they mirror each
other — typing in one changes what the other shows too, and closing a
window doesn't end the session (`prefix d` or just closing the terminal
both just detach; the session and everything running in it survives).
That's the point — reopen a terminal days later and your panes, running
builds, and SSH connections are exactly where you left them. If instead
you want separate, independent sessions per project (so two terminal
windows don't show the same thing), name them explicitly instead of
relying on auto-attach: `tmux new -A -s myproject`, `tmux ls` to see
what's running, `prefix s` to switch between sessions without detaching.

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
