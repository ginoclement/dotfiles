#!/usr/bin/env bash
#
# Dotfiles installer for Manjaro.
#   ./install.sh              symlink dotfiles into $HOME (backs up existing files)
#   ./install.sh --packages   also install required packages via pacman
#
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

PACKAGES=(
  zsh zsh-autosuggestions zsh-syntax-highlighting zsh-completions
  tmux neovim git
  starship fzf zoxide
  bat eza ripgrep fd
)

install_packages() {
  echo "==> Installing packages with pacman"
  sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"
}

# link <repo-relative-path> <target-path>
link() {
  local src="$DOTFILES_DIR/$1" dest="$2"

  # Already linked to the right place — nothing to do
  if [ "$(readlink -f "$dest" 2>/dev/null)" = "$src" ]; then
    echo "    ok: $dest"
    return
  fi

  # Back up anything that's already there
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    mkdir -p "$BACKUP_DIR"
    echo "    backup: $dest -> $BACKUP_DIR/"
    mv "$dest" "$BACKUP_DIR/"
  fi

  mkdir -p "$(dirname "$dest")"
  ln -s "$src" "$dest"
  echo "    link: $dest -> $src"
}

if [ "${1:-}" = "--packages" ]; then
  install_packages
fi

echo "==> Linking dotfiles"
link .zshrc               "$HOME/.zshrc"
link .aliases             "$HOME/.aliases"
link .tmux.conf           "$HOME/.tmux.conf"
link .gitconfig           "$HOME/.gitconfig"
link .config/starship.toml "$HOME/.config/starship.toml"
link .config/nvim         "$HOME/.config/nvim"

if [ "$(basename "$SHELL")" != "zsh" ] && command -v zsh >/dev/null; then
  echo
  echo "==> Setting zsh as the default shell (you may be asked for your password)"
  chsh -s "$(command -v zsh)"
fi

echo
echo "Done. Next steps:"
echo "  - Open a new terminal (or log out/in) to get zsh + starship"
echo "  - Start tmux with 't' — TPM installs plugins automatically on first launch"
echo "    (or press Ctrl-Space then I to install/update plugins manually)"
[ -d "$BACKUP_DIR" ] && echo "  - Old files were backed up to $BACKUP_DIR"
