########## Scripts to run on shell startup ##########

# Autosuggestion conf
bindkey ',,' autosuggest-execute
bindkey ',m' autosuggest-accept
bindkey ',.' autosuggest-clear

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/kartavyasharma/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/kartavyasharma/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/kartavyasharma/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/kartavyasharma/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# bun completions
[ -s "/Users/kartavyasharma/.bun/_bun" ] && source "/Users/kartavyasharma/.bun/_bun"

# Bun
export BUN_INSTALL="/Users/kartavyasharma/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

[ -f "/Users/kartavyasharma/.ghcup/env" ] && source "/Users/kartavyasharma/.ghcup/env" # ghcup-env

# Kitty Theme
# eval "kitty @ set-colors -c $HOME/base16-kitty/colors/$(cat ~/.config/kitty/.base16_theme).conf"

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Java Environment
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

# Nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
