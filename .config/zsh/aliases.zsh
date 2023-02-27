# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

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

# Extensions
alias lst="exa -l -h --tree --level=3 --ignore-glob="node_modules""
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
alias saf=open -a "Safari"

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

# Tmux
# alias tls="tmux list"

# Scripts
alias game="bash ~/documents/Code/Scripts/game.sh"
alias comp="bash ~/documents/Code/Scripts/comp.sh"
alias fresh="bash ~/documents/Code/Scripts/fresh_space.sh"
alias fin="bash ~/documents/Code/Scripts/newfile.sh"
alias nmd="bash ~/documents/Code/Scripts/pandoc_mkd.sh"
alias tm="bash ~/.config/tmux/scripts/env_theme_change.sh"

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
            cd ~/$find_out
        elif [[ $g_or_l = "Local" ]]; then
            cd ./$find_out
        fi
    else
        cdir $curr_dir
    fi
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

# brew backup
bkpb () {
    rm ~/.config/misc/brew/brew_casks.txt ~/.config/misc/brew/brew_formulae.txt
    brew list --formulae >> ~/.config/misc/brew/brew_formulae.txt
    brew list --casks >> ~/.config/misc/brew/brew_casks.txt
    config add ~/.config/misc/brew/brew_casks.txt ~/.config/misc/brew/brew_formulae.txt
    config commit -m "Updated brew lists"
    config push
}

# python backup
bkpp () {
    curr_dir=$(pwd)
    cd ~/.config/misc/python
    pie bkp.py
    config add python.txt
    config commit -m "Update python module list"
    config push
    cd $curr_dir
}

# kill vs code process
kvs () {
    ps aux | grep -i vscode | less
    pkill -i vscode
}

# tmux scripts
init_csm () {
    # Set session and window names
    SESSION="csm_web"
    SESSIONEXISTS=$(tmux list-sessions | grep $SESSION)
    W1="git"

    # Only create new session if it already doesn't exist
    if [[ "$SESSIONEXISTS" = "" ]]; then
        BASE="~/Documents/berkeley/extracurricular/clubs/CSM/repo"
        MANAGED="$BASE/csm_web/csm_web/"
        ACTIVATE="cdir $BASE && sc env/bin/activate && cdir $MANAGED"
        tmux new -s $SESSION -d -c "$BASE"
        tmux split-window -h -t $SESSION. -d
        tmux split-window -v -t $SESSION.1 -d
        tmux send-keys -t $SESSION.1 "$ACTIVATE && pie manage.py runserver" Enter
        tmux send-keys -t $SESSION.2 "$ACTIVATE" Enter
        tmux send-keys -t $SESSION.0 "$ACTIVATE" Enter
        tmux send-keys -t $SESSION.0 v Enter
        tmux select-pane -t $SESSION.0
        tmux new-window -t $SESSION -d -n $W1
        tmux send-keys -t $SESSION:$W1 "$ACTIVATE && lazygit" Enter
    fi

    tmux switch -t $SESSION
}

# list and choose tmux sessions
tlst () {
    SESSION=$(tmux list-sessions -F \#S | gum filter --placeholder "Pick session...")
    tmux switch-client -t $SESSION || tmux attach -t $SESSION
}

# temporary data 8 test scripts
fix_tests () { 
    for file in tests/*.py; do \
        { echo 'OK_FORMAT = True'; cat "$file" } > "$file.tmp" && mv "$file.tmp" "$file"
    done
}
