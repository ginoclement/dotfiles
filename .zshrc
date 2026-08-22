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
