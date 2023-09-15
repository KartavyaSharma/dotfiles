# Path to your oh-my-zsh installation.
export ZSH="/Users/kartavyasharma/.oh-my-zsh"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(git zsh-autosuggestions zsh-syntax-highlighting fzf-tab autojump tmux)

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

############## LOADING ENV VARIABLES #######################
# Sourcing environment variables
source ~/.config/zsh/.env.sh
############################################################

############# IMPORTING STARTUP SCRIPTS ####################
# Source script file
source ~/.config/zsh/rcscripts.sh
############################################################

############## SOURCING ALIASES ############################
# Sourcing aliases
source ~/.config/zsh/aliases.zsh
############################################################
