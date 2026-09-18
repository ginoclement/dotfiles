# ~/.zshrc — Gino Clement
# Manjaro + zsh + starship + tmux setup

# --- Environment ---
export EDITOR=nvim
export VISUAL=nvim
export PATH="$HOME/.local/bin:$PATH"

# --- History ---
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt INC_APPEND_HISTORY       # write to history immediately, not on exit
setopt SHARE_HISTORY            # share history across open terminals
setopt HIST_IGNORE_DUPS         # skip immediate duplicates
setopt HIST_IGNORE_ALL_DUPS     # remove older duplicates
setopt HIST_IGNORE_SPACE        # commands starting with a space stay out of history
setopt HIST_REDUCE_BLANKS

# --- Behavior ---
setopt AUTO_CD                  # type a directory name to cd into it
setopt INTERACTIVE_COMMENTS     # allow # comments on the command line
unsetopt BEEP

# --- Completion ---
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'   # case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# --- Keybindings ---
bindkey -e                      # emacs-style line editing
# Up/Down search history for what's already typed
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
# Ctrl+Left/Right word jumps
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# --- Aliases ---
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

# --- fzf: Ctrl-R history search, Ctrl-T file search, Alt-C cd ---
[[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
[[ -f /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh
command -v fd >/dev/null && export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'

# --- Plugins (pacman: zsh-autosuggestions zsh-syntax-highlighting) ---
[[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# syntax highlighting must be sourced last of the plugins
[[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# --- zoxide: smarter cd (use `z <dir>` / `zi` for interactive) ---
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

# --- Starship prompt ---
command -v starship >/dev/null && eval "$(starship init zsh)"

# --- Dotfiles update check ---
# Only runs for a genuinely new terminal window (guarded by the same
# "not already inside tmux" check as the tmux auto-launch below), so it
# can't nag you on every pane split. Reads a cached status file instead of
# hitting the network directly — see bin/check-updates.sh for why — then
# kicks off that script in the background to refresh the cache for next
# time. You'll only ever be prompted based on the *previous* background
# check's result, so opening a terminal never waits on the network.
if [[ -o interactive ]] && [[ -z "$TMUX" ]]; then
    DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
    DOTFILES_STATUS="$HOME/.cache/dotfiles/update-status"

    if [[ -f "$DOTFILES_STATUS" ]] && [[ "$(<"$DOTFILES_STATUS")" == behind:* ]]; then
        IFS=: read -r _ df_count df_branch < "$DOTFILES_STATUS"
        echo "dotfiles: $df_count update(s) available on $df_branch."
        if read -q "?Install now? [y/N] "; then
            echo
            (cd "$DOTFILES_DIR" && git pull --ff-only && ./install.sh) \
                && echo "current" > "$DOTFILES_STATUS"
        else
            echo
        fi
    fi

    [[ -x "$DOTFILES_DIR/bin/check-updates.sh" ]] && "$DOTFILES_DIR/bin/check-updates.sh" &!
fi

# --- Auto-launch tmux ---
# Every new terminal (kitty, konsole, whatever) lands in the "main" tmux
# session instead of a bare shell. `-A` means "attach if it exists, create
# it if not" — so this always converges on one persistent session.
# Guards: only for interactive shells, not already inside tmux, and not
# inside a VS Code / IDE integrated terminal (those handle their own
# multiplexing and get confused by this).
if [[ -o interactive ]] && [[ -z "$TMUX" ]] && [[ -z "$VSCODE_INJECTION" ]] && command -v tmux >/dev/null; then
    exec tmux new-session -A -s main
fi
