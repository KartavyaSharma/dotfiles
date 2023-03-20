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

source ~/.zplug/init.zsh

# zplug 'wfxr/forgit'

source $ZSH/oh-my-zsh.sh

# zsh aliases
source ~/.config/zsh/aliases.zsh

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
eval $(thefuck --alias FUCK)

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

export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

export PATH="/Users/kartavyasharma/Downloads/apache-maven-3.8.7/bin:$PATH"
export DATA_PROJ="/Users/kartavyasharma/Documents/berkeley/Academics/sp23/cs186/projects/"

# TMUX theme options
export ZSH_DARK=1

# Security Lists 
export SEC_LIST="/Users/kartavyasharma/documents/Code/wordlists/SecLists"

# Word Lists
export WORD_LIST="/Users/kartavyasharma/documents/Code/wordlists/english-words"

# Editor Flag
export EDITOR="nvim"

# Batpipe Colors
export BATPIPE=color

# Scripts
export SCRIPTS="/Users/kartavyasharma/.config/zsh/scripts"
