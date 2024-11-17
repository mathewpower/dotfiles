# Instant Prompt: Initialize Powerlevel10k instant prompt before any console I/O
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Define the behavior of Powerlevel10k's instant prompt
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
source "$ZSH/oh-my-zsh.sh"

# Powerlevel10k
BREW_PREFIX=$(brew --prefix)
source "$BREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme"
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh || echo "Run 'p10k configure' to set up Powerlevel10k."

# Plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"

# Zsh Autosuggestions
if [[ -f "$ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "$ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
else
  echo "Warning: zsh-autosuggestions not found at $ZSH_CUSTOM/plugins/zsh-autosuggestions."
fi

# Zsh Syntax Highlighting
if [[ -f "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
else
  echo "Warning: zsh-syntax-highlighting not found at $ZSH_CUSTOM/plugins/zsh-syntax-highlighting."
fi

# Fuzzy Finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Aliases
alias t="tmux"
alias rec="asciinema rec"
alias top="htop"

# TheFuck
eval $(thefuck --alias)
alias ff="fuck --yeah"

# Git Aliases
alias gst="git status"
alias gpl="git pull"
alias gps="git push"
alias gcm="git commit -m"
alias gco="git checkout"
alias gbr="git branch"
alias lg="lazygit"

# Pyenv and Pyenv-Virtualenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"

# SSH Agent for 1Password
export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

# Environment Variables
export PATH="$PATH:$BREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin:/opt/homebrew/opt/openjdk/bin:${KREW_ROOT:-$HOME/.krew}/bin"
export DYLD_LIBRARY_PATH="$DYLD_LIBRARY_PATH:$BREW_PREFIX/lib"

# Direnv
eval "$(direnv hook zsh)"

# History Substring Search
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
source "$BREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh"

# Lazy Loading NVM
export NVM_DIR="$HOME/.nvm"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  function lazy_nvm() {
    source "$NVM_DIR/nvm.sh"
    source "$NVM_DIR/bash_completion"
    unset -f lazy_nvm
  }
  alias nvm="lazy_nvm"
fi

