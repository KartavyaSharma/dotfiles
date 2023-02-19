# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

# General
alias lst="exa -l -h --tree --level=3 --ignore-glob="node_modules""
alias ls="exa -l -h --sort=modified"
alias lsty="exa -l -h --sort=name"
alias pyde="conda activate spyder-env && spyder"
alias cex="conda deactivate"
alias cl="clear"
alias vim="nvim"
alias v="vim"
alias git="hub"
alias saf="open -a \"Safari\""
alias br="links"
alias cr="cargo"
alias pie="python3"
alias ipy="ipython"
alias lg="lazygit"
alias de="deactivate"
alias javainfo="/usr/libexec/java_home -V"
alias idea="open -na \"IntelliJ IDEA.app\" --args \"$@\""
alias pdf="sioyek --new-window"
alias sioyek-keys="sioyek --execute-command keys_user"
alias fbat="fzf --preview 'bat {-1} --color=always'"
alias cat=prettybat
alias bgrep=batgrep
alias man=batman
alias gl=glances

# Fast download move
alias mvdw='mv $(fd --absolute-path --base-directory ~/Downloads/ | fzf) .'

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
alias nmd="bash ~/documents/Code/Scripts/pandoc_mkd.sh"
alias tm="bash ~/.config/tmux/scripts/env_theme_change.sh"

# cd + ls
d () { z "$@" && exa -l -h --sort=modified;}

# edit on create
mkf () { touch "$@" && nvim "$@"}

# cd on mkdir
mkd () { mkdir "$@" && d "$@" }

# markdown stuff
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

# faster git
fcp () {
    git add "$1"
    git commit -m "$2"
    git push
}

# pipe git show into cat (or bat)
gshow () {
    git  show "$@" | bat -l rs
}

# git diff piped into fzf
gdiff () {
    preview="git diff $@ --color=always -- {-1}"
    git diff $@ --name-only | fzf -m --ansi --preview $preview
}

# globally searching for files
fdir () {
    find_out=$(fd --hidden --type directory --base-directory ~ | fzf)
    curr_dir=$(pwd)

    if [[ $find_out ]]; then
        d $find_out
    else
        cd $curr_dir
    fi
}

# locally searching for files
cdir ()  {
    find_out=$(fd --hidden --type directory | fzf)
    curr_dir=$(pwd)

    if [[ $find_out ]]; then
        d $find_out
    else
        cd $curr_dir
    fi
}
