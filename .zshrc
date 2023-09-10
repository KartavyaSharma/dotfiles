# Path to your oh-my-zsh installation.
export ZSH="/Users/kartavyasharma/.oh-my-zsh"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(git zsh-autosuggestions zsh-syntax-highlighting fzf-tab autojump tmux)

# Autosuggestion conf
bindkey ',,' autosuggest-execute
bindkey ',m' autosuggest-accept
bindkey ',.' autosuggest-clear

# Plugin vars
ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_DEFAULT_SESSION_NAME="home"

source ~/.zplug/init.zsh

# zplug 'wfxr/forgit'

# Source OH MY ZSH
source $ZSH/oh-my-zsh.sh

# fuck
eval "$(thefuck --alias)"

# Starship init
eval "$(starship init zsh)"

# Hub
eval "$(hub alias -s)"

# Zoxide
eval "$(zoxide init zsh)"

# Bat preprocessor
eval "$(batpipe)"

# ...
eval $(thefuck --alias fk)

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

# Java Environment
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

############## DO NOT MOVE THIS BLOCK ######################
# Sourcing environment variables
source ~/.config/zsh/.env.sh
############################################################

############# IMPORTING STARTUP SCRIPTS ####################
# Source script file
source ~/.config/zsh/rcscripts.sh
############################################################

# Nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

############## DO NOT ADD ANYTHING BELOW THIS ##############
# Sourcing aliases
source ~/.config/zsh/aliases.zsh
############################################################
