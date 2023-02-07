# Path to your oh-my-zsh installation.
export ZSH="/Users/kartavyasharma/.oh-my-zsh"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting fzf-tab autojump tmux)

# Plugin vars
ZSH_TMUX_AUTOSTART=true

source ~/.zplug/init.zsh

# zplug 'wfxr/forgit'

source $ZSH/oh-my-zsh.sh

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

# General
alias gocourse="cd ~/documents/berkeley/Academics"
alias gocode="cd ~/documents/Code"
alias god="cd ~/documents"
alias lst="exa -l -h --tree --level=3 --ignore-glob="node_modules""
alias ls="exa -l -h --sort=modified"
alias lsty="exa -l -h --sort=name"
alias pyde="conda activate spyder-env && spyder"
alias cex="conda deactivate"
alias cl="clear"
alias vim="nvim"
alias v="vim"
alias club="cd ~/documents/berkeley/Co-curricular/clubs/csm"
alias git="hub"
alias saf="open -a \"Safari\""
alias br="links"
alias cr="cargo"
alias pie="python3"
alias ipy="ipython"
alias lg="lazygit"
alias de="deactivate"
alias t="cd ~/Downloads && ./taskwarrior-tui && cd ~/Downloads/"
alias javainfo="/usr/libexec/java_home -V"
alias idea="open -na \"IntelliJ IDEA.app\" --args \"$@\""
alias database="cd ~/Documents/berkeley/Academics/sp23/cs186/projects/proj1/sp23-proj1-KartavyaSharma && idea"

# Dotfiles
alias zsource="source ~/.zshrc"
alias nplugdir="cd ~/.config/nvim/lua/configs"
alias nplug="vim ~/.config/nvim/lua/plugins.lua"
alias vconfig="vim ~/.vimrc"
alias zconfig="vim ~/.zshrc"
alias bconfig="vim ~/.bashrc"
alias nconfig="vim ~/.config/nvim/init.vim"

# Dotfile backup
alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
alias bkpz="cd && config add .zshrc && config commit -m \"Updated .zshrc\" && config push"

# Tmux
alias tls="tmux list"

# Scripts
alias game="bash ~/documents/Code/Scripts/game.sh"
alias comp="bash ~/documents/Code/Scripts/comp.sh"
alias fresh="bash ~/documents/Code/Scripts/fresh_space.sh"
alias fin="bash ~/documents/Code/Scripts/newfile.sh"
alias nmd="bash ~/Documents/Code/Scripts/pandoc_mkd.sh"

# Starship init
eval "$(starship init zsh)"

# Hub
eval "$(hub alias -s)"

# Zoxide
eval "$(zoxide init zsh)"

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

d () { z "$@" && exa -l -h --sort=modified;}
mkf () { touch "$@" && nvim "$@"}
mkd () { mkdir "$@" && d "$@" }

# Markdown stuff
cplmd () { 
    inp=$1
    filtered=${inp%.*}
    pandoc -f markdown-implicit_figures -t pdf "$inp" > "$filtered.pdf";
    saf "$filtered.pdf"
    open -a "iTerm"
}

# rm alt
del () {
    mv "$@" ~/.Trash/
}
