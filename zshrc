# --- Start recommended ~/.zshrc content ---

# --- Essential environment exports (apply to both interactive and non-interactive shells) ---
export HOMEBREW_NO_ANALYTICS=1
ZSH_DISABLE_COMPFIX=true

# PATH entries user wants for scripts/CI (keep before guard if you need them available for non-interactive runs)
export PATH="$HOME/bin:$HOME/.local/bin:/opt/homebrew/bin:$HOME/.rbenv/bin:./bin:./node_modules/.bin:$PATH:/usr/local/sbin"

# Locale and editor envs for scripts
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export BUNDLER_EDITOR=code
export EDITOR=code
export PYTHONBREAKPOINT=ipdb.set_trace

# Optional: other non-interactive safe exports can go above

# -----------------------
# Only continue for interactive shells (prevents blocking for non-interactive agent runs)
[[ -o interactive ]] || return
# -----------------------

[[ "$TERM_PROGRAM" == "vscode" ]] && . "$( code --locate-shell-integration-path zsh)"

# Enable Powerlevel10k instant prompt. Keep near top of interactive section.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load powerlevel10k theme (interactive only)
if [[ -f "/opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
  source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
fi

# Oh-My-Zsh setup (single definition)
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

# Plugins (keep a single plugins=(...) block)
plugins=(git gitfast last-working-dir common-aliases zsh-syntax-highlighting history-substring-search)

# Actually load Oh-My-Zsh (interactive)
if [[ -d "$ZSH" && -f "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
fi

# Unalias adjustments
unalias rm 2>/dev/null || true
unalias lt 2>/dev/null || true

# rbenv, pyenv and other tools - load if present (interactive)
type -a rbenv > /dev/null && eval "$(rbenv init -)"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
type -a pyenv > /dev/null && eval "$(pyenv init -)" && eval "$(pyenv virtualenv-init - 2> /dev/null)" && RPROMPT+='[🐍 $(pyenv version-name)]'

# nvm (interactive)
export NVM_DIR="$HOME/.nvm"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  # Load nvm
  source "$NVM_DIR/nvm.sh"
fi
if [[ -s "$NVM_DIR/bash_completion" ]]; then
  source "$NVM_DIR/bash_completion"
fi

# nvm auto-use hook
autoload -U add-zsh-hook
load-nvmrc() {
  if command -v nvm >/dev/null 2>&1; then
    local node_version="$(nvm version 2>/dev/null)"
    local nvmrc_path="$(nvm_find_nvmrc 2>/dev/null || true)"

    if [[ -n "$nvmrc_path" ]]; then
      local nvmrc_node_version
      nvmrc_node_version=$(nvm version "$(cat "$nvmrc_path")" 2>/dev/null || true)
      if [[ "$nvmrc_node_version" == "N/A" ]]; then
        nvm install
      elif [[ "$nvmrc_node_version" != "$node_version" ]]; then
        nvm use --silent
      fi
    elif [[ "$node_version" != "$(nvm version default 2>/dev/null)" ]]; then
      nvm use default --silent
    fi
  fi
}
type -a nvm > /dev/null && add-zsh-hook chpwd load-nvmrc
type -a nvm > /dev/null && load-nvmrc

# Aliases file
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

# Deno env (interactive; only source if file exists)
if [[ -f "$HOME/.deno/env" ]]; then
  source "$HOME/.deno/env"
fi

# mise activations (interactive). If these must run for non-interactive scripts, move them above the guard and ensure they don't prompt.
if [[ -x "$HOME/.local/bin/mise" ]]; then
  eval "$($HOME/.local/bin/mise activate zsh)"
  eval "$($HOME/.local/bin/mise activate)"
fi

# zsh-autosuggestions & syntax highlighting (interactive only)
if [[ -f "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
if [[ -f "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# eza alias
alias ls="eza --icons=always"

# zoxide
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# History settings (interactive)
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# Completion / keybinds
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# Final interactive-only configs...
# -----------------------
# Add any other interactive-only commands below this line.
# -----------------------

# --- End recommended ~/.zshrc content ---

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export XDG_CONFIG_HOME="$HOME/.config"
