# Path to your oh-my-zsh installation.
export ZSH="/Users/kartavyasharma/.oh-my-zsh"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(git zsh-autosuggestions zsh-syntax-highlighting fzf-tab autojump tmux)

# Startup script file 
source ~/.config/zsh/.startup

# Environment variables 
source ~/.config/zsh/.env

# Aliases
source ~/.config/zsh/.alias

# Functions
source ~/.config/zsh/.functions
