#!/bin/bash

set -e

echo "🚀 Starting bootstrap script for development environment setup."

# Default to ZSH
if [[ $SHELL != "/bin/zsh" ]]; then
  echo "⚙️ Changing default shell to Zsh..."
  chsh -s $(which zsh)
fi

# Determine the absolute path to the dotfiles directory
DOTFILES_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Update and Install Homebrew
if ! command -v brew &>/dev/null; then
  echo "🍺 Homebrew not found. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "🍺 Homebrew found. Updating..."
  brew update
fi

# Install dependencies using Brewfile
if [[ -f "$DOTFILES_DIR/Brewfile" ]]; then
  echo "📦 Installing packages from Brewfile..."
  brew bundle --file="$DOTFILES_DIR/Brewfile"
else
  echo "❌ Brewfile not found in $DOTFILES_DIR. Please include it in your dotfiles repository."
  exit 1
fi

# Install Oh My Zsh
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  echo "⚡ Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "⚡ Oh My Zsh is already installed."
fi

# Install Zsh Plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
echo "🔌 Installing Zsh plugins..."

# zsh-autosuggestions
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
  echo "📥 Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
else
  echo "✅ zsh-autosuggestions is already installed."
fi

# zsh-syntax-highlighting
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
  echo "📥 Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
else
  echo "✅ zsh-syntax-highlighting is already installed."
fi

# Install fzf Key Bindings and Completions
if command -v fzf &>/dev/null; then
  echo "✨ Setting up fzf key bindings and completions..."
  "$(brew --prefix)/opt/fzf/install" --all --no-bash --no-fish
else
  echo "❌ fzf not found. Ensure Brewfile includes it."
fi

# Set up pyenv
if command -v pyenv &>/dev/null; then
  echo "🐍 Setting up pyenv and pyenv-virtualenv..."
  eval "$(pyenv init --path)"
  eval "$(pyenv virtualenv-init -)"
else
  echo "❌ pyenv not found. Ensure Brewfile includes it."
fi

# Set up NVM
echo "🔧 Setting up NVM..."
NVM_DIR="$HOME/.nvm"
if [[ ! -d "$NVM_DIR" ]]; then
  mkdir -p "$NVM_DIR"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
else
  echo "📂 NVM directory already exists."
fi

# Link .zshrc
echo "🔗 Linking .zshrc from dotfiles..."
if [[ ! -f "$HOME/.zshrc" ]]; then
  ln -s "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
  echo "🔗 Linked .zshrc."
else
  echo "🔗 .zshrc already linked."
fi

# Final Steps
echo "🎉 Bootstrap completed. Restart your terminal or run 'source ~/.zshrc' to apply changes."

