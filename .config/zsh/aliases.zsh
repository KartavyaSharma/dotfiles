# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

################# ALIASES #################

# General
alias cl=clear
alias vim=nvim
alias v=vim
alias git=hub
alias br=links
alias cr=cargo
alias pie=python3
alias ipy=ipython
alias lg=lazygit
alias de=deactivate
alias cat=prettybat
alias bgrep=batgrep
alias man=batman
alias gl=glances
alias sc=source
alias task=dstask

# Extensions
alias lst="exa -l -h --tree --level=3 --ignore-glob="node_modules""
alias game="watch -n 0.1 sudo ifconfig awdl0 down"
alias cpcomp="g++ -std=c++11 -o a __master.cpp && ./a"
alias ls="exa -l -h --sort=modified"
alias lsty="exa -l -h --sort=name"
alias pyde="conda activate spyder-env && spyder"
alias cex="conda deactivate"
alias javainfo="/usr/libexec/java_home -V"
alias idea="open -na \"IntelliJ IDEA.app\" --args \"$@\""
alias pdf="sioyek --new-window"
alias sioyek-keys="sioyek --execute-command keys_user"
alias fbat="fzf --preview 'bat {-1} --color=always'"
alias cpath="fbat | pbcopy"
alias sbat="fbat --exec bat {}"
alias pcp="gpath | pbcopy"
alias saf=open -a "Safari"
alias ktheme="kitty +kitten themes --reload-in=all ${@}"

# Fast download move
alias mvdw='mv $(fd --absolute-path --base-directory ~/Downloads/ | fzf) .'

# Dotfiles
alias zsc="source ~/.zshrc"
alias nplugdir="cd ~/.config/nvim/lua/configs"
alias nplug="vim ~/.config/nvim/lua/plugins.lua"
alias vconf="vim ~/.vimrc"
alias zconf="vim ~/.zshrc"
alias bconf="vim ~/.bashrc"
alias nconf="vim ~/.config/nvim/init.vim"

# Dotfile backup
alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
alias bkpz="cd && config add .zshrc && config commit -m \"Updated .zshrc\" && config push"

# Competitive programming scripts
alias fresh="bash ~/documents/Code/Scripts/fresh_space.sh"
alias fin="bash ~/documents/Code/Scripts/newfile.sh"

# Scripts
alias nmd="$SCRIPTS/pandoc_markdown.sh"
alias bkp="$SCRIPTS/bkp_choose.sh"

# Synth Shell 
# source "$SCRIPTS/synth.sh"

# tmux scripts
alias init_csm="$SCRIPTS/tmux/init_csm.sh"
alias resume="$SCRIPTS/tmux/resume.sh"
alias neetcode="$SCRIPTS/tmux/neetcode.sh"

# Compiled binaries
alias ghidra="~/Documents/berkeley/extracurricular/clubs/berke1337/ghidra_10.2.3_PUBLIC/ghidraRun"

################# QOL GENERAL SCRIPTS #################

# cd + ls
d () { z "$@" && exa -l -h --sort=modified;}
cdir () { cd "$@" && exa -l -h --sort=modified;}

# edit on create
mkf () { touch "$@" && nvim "$@"}

# cd on mkdir
mkd () { mkdir "$@" && d "$@" }

# markdown compile
cplmd () { 
    inp=$1
    filtered=${inp%.*}
    pandoc -f markdown-implicit_figures -t pdf "$inp" > "$filtered.pdf";
    saf "$filtered.pdf"
    open -a "iTerm"
}

# c++ compile
cpp () {
    inp=$1
    filtered=${inp%.*}
    g++ -std=c++11 -o $filtered $inp && ./$filtered
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

# search directories globally or locally
sd () {
    g_or_l=$(gum choose "Global" "Local")
    base_dir="~"
    if [[ $g_or_l = "Global" ]]; then
        find_out=$(fd --hidden --type directory --base-directory ~ | fzf)
    elif [[ $g_or_l = "Local" ]] then
        find_out=$(fd --hidden --type directory --base-directory . | fzf)
    fi
    curr_dir=$(pwd)
    if [[ $find_out ]]; then
        if [[ $g_or_l = "Global" ]]; then
            cdir ~/$find_out
        elif [[ $g_or_l = "Local" ]]; then
            cdir ./$find_out
        fi
    else
        cd $curr_dir
    fi
}

# copy any file path on ~, narrow search by directory, then by files
gpath () {
    curr_dir=$(pwd)
    find_out=$(fd --hidden --type directory --base-directory ~ | fzf)
    if [[ $find_out ]]; then
        cd ~/$find_out
        get_file=$(fbat)
        complete_path="~/$find_out$get_file"
        echo $complete_path
    else
        echo ""
    fi 
    cd $curr_dir
}

# move any file on ~ path, narrow by directory, then by files
gmv () {
    curr_dir=$(pwd)
    cd
    get_path=$(gpath)
    filtered=".${get_path:1}"
    echo $filtered
    if [[ ! -z "$get_path" ]]; then 
        mv "${filtered}" "${curr_dir}"
    fi
    cd $curr_dir
}

# file preview for vim
vf () {
    selected=$(fzf --preview 'bat {-1} --color=always')
    curr_dir=$(pwd)
    if [[ $selected ]]; then
        v $selected
    else
        cd $curr_dir
    fi
}

# kill vs code process
kvs () {
    ps aux | grep -i vscode | less
    pkill -i vscode
}

# list and choose tmux sessions
tlst () {
    SESSION=$(tmux list-sessions -F \#S | gum filter --placeholder "Pick session...")
    tmux switch-client -t $SESSION || tmux attach -t $SESSION
}

################# TEMP SCRIPTS #################

# temporary data 8 test scripts
fix_tests () { 
    for file in tests/*.py; do \
        { echo 'OK_FORMAT = True'; cat "$file" } > "$file.tmp" && mv "$file.tmp" "$file"
    done
}
