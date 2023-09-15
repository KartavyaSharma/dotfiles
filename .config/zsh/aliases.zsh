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
alias pdf=sioyek

# Extensions
alias lst="exa -l -h --tree --level=3 --ignore-glob=\"node_modules|env|build|dist\""
alias cpcomp="g++ -std=c++11 -o a __master.cpp && ./a"
alias ls="exa -l -h --sort=modified"
alias lsty="exa -l -h --sort=name"
alias pyde="conda activate spyder-env && spyder"
alias cex="conda deactivate"
alias javainfo="/usr/libexec/java_home -V"
alias idea="open -na \"IntelliJ IDEA.app\" --args \"$@\""
alias sioyek-keys="sioyek --execute-command keys_user"
alias fbat="fzf --preview 'bat {-1} --color=always'"
alias cpath="fbat | pbcopy"
alias sbat="fbat --exec bat {}"
alias gcopy="gpath | pbcopy"
alias saf=open -a "Safari"
alias ktheme="kitty +kitten themes --reload-in=all ${@}"
alias tre="tmux rename-session ${@}"
alias kll="pkill -f ${@}"

# Retired
# alias game="watch -n 0.1 sudo ifconfig awdl0 down"

# Fast download copy/move
alias mvdw='mv $(fd --absolute-path --base-directory ~/Downloads/ | fzf) .'
alias cpdw='cp $(fd --absolute-path --base-directory ~/Downloads/ | fzf) .'

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
alias pconf="/usr/bin/git --git-dir=$HOME/.pcfg/ --work-tree=$HOME"
alias bkpz="cd && config add .zshrc && config commit -m \"Updated .zshrc\" && config push"

# Competitive programming scripts
alias fresh="bash ~/documents/Code/Scripts/fresh_space.sh"
alias fin="bash ~/documents/Code/Scripts/newfile.sh"

# Scripts
alias nmd="$SCRIPTS/pandoc_markdown.sh"
alias bkp="$SCRIPTS/bkp_choose.sh"
alias cecho="$SCRIPTS/utils/echo/echo.sh"

# tmux scripts
alias init_csm="$SCRIPTS/tmux/init_csm.sh"
alias resume="$SCRIPTS/tmux/resume.sh"
alias neetcode="$SCRIPTS/tmux/neetcode.sh"
alias game="$SCRIPTS/tmux/game.sh"
alias setup_hive="$SCRIPTS/tmux/hive.sh"
alias linuxvm="sc $SCRIPTS/tmux/linuxvm.sh"

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
    cecho -c green -t "Choose scope of search (default: Global (~) [fast])"
    declare -a opts
    opts=("Global (~) [fast]" "Global (~)" "Local (.)" "System (/) [slow]")
    g_or_l=$(gum choose ${opts[@]})
    base_dir="~"
    if [[ $g_or_l = "${opts[1]}" ]]; then
        find_out=$(fd --hidden --type directory --base-directory ~ --exclude .git --exclude miniconda3 --exclude node_modules --exclude Application\ Support --exclude .gradle --exclude '*cache*' --exclude 'python*' --exclude WebKit --exclude .vscode --exclude org --exclude '*env' --exclude bin | fzf)
    elif [[ $g_or_l = "${opts[2]}" ]]; then
        find_out=$(fd --hidden --type directory --base-directory ~ | fzf)
    elif [[ $g_or_l = "${opts[3]}" ]]; then
        find_out=$(fd --hidden --type directory --base-directory . | fzf)
    elif [[ $g_or_l = "${opts[4]}" ]]; then
        cecho -c yellow -t "WARNING: You are searching the entire system. This may take a while"
        cecho -c yellow -t "This operation needs sudo privilages"
        # Get sudo password
        GETPASS=$(gum input --password --placeholder "Enter sudo password")
        # Check validity of password
        valid=$(python3 $SCRIPTS/utils/validate --password=$GETPASS)
        if [[ $valid = 1 ]]; then    
            find_out=$(echo $GETPASS | sudo -S fd --hidden --type directory --max-depth 20 --base-directory / | fzf)
        else
            echo "Incorrect sudo password."
        fi
    else
        cecho -c red -t "No scope selected!"
    fi
    curr_dir=$(pwd)
    if [[ $find_out ]]; then
        if [[ $g_or_l = ${opts[1]} || $g_or_l = ${opts[2]} ]]; then
            cdir ~/$find_out
        elif [[ $g_or_l = ${opts[3]} ]]; then
            cdir ./$find_out
        elif [[ $g_or_l = ${opts[4]} ]]; then
            cdir /$find_out
        fi
    else
        cecho -c red -t "No directory selected!"
        cd $curr_dir
    fi
}

# return any file path on ~, narrow search by directory, then by files
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
    selected=""
    if [[ $# -eq 0 ]]; then
        selected=$(fd --hidden --exclude .git --exclude miniconda3 --exclude node_modules --exclude Application\ Support --exclude .gradle --exclude '*cache*' --exclude WebKit --exclude .vscode --exclude org --exclude '*env' --exclude bin | fzf --preview 'bat {-1} --color=always')
    fi
    for flag in "$@"; do
        case $flag in
            -l | --loose) # Start
                selected=$(fd --hidden | fzf --preview 'bat {-1} --color=always')
                ;;
            -h | --help) # Help
                echo "Usage: vf [OPTION]"
                echo "Options:"
                echo "  -l    Loose search"
                echo "  -h    Display this help message"
                echo "  *     Default search" 
                ;;
        esac
    done
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

tn () {
    tmux new-session -d -s $1
    tmux switch -t $1
}

sm () {
    curr_dir=$(pwd)
    cd && cd $SCRIPTS/tmux/session_management/
    python3 session_manager_script.py
    cd && cd $curr_dir
}

################# TEMP SCRIPTS #################

# temporary data 8 test scripts
fix_tests () { 
    for file in tests/*.py; do \
        { echo 'OK_FORMAT = True'; cat "$file" } > "$file.tmp" && mv "$file.tmp" "$file"
    done
}

# temporary cs161 scripts summer 2023
hive () {
    ssh "cs161-aam@hive${1}.cs.berkeley.edu"
}

# Decal Linux VM Scripts

linux () {
    cecho -c yellow -t "WARNING: You are running the Azure Linux VM w/o the appropriate start/stop wrapper. This may lead to unintentional charges on your Azure account."
    ssh -i $LVMKEY kurt@$LVMIP
}

# Login to decal vm
dvm () {
    ssh kartavya@kartavya.decal.xcf.sh
}

# Move to linux vm
scplinux () {
    scp -i $LVMKEY $1 kurt@$LVMIP:$2
}

# Log new job application
logjob () {
    cwd=$(pwd)
    cd ~/Documents/Code/trapp
    source start.sh
    cd $cwd
}

# Execute command on CSM docker container
dexec () {
    docker compose exec django $@ 
}

# Command to start and stop dev environment for CSM project
csm () {
    curr=$(pwd)
    if [[ $# -eq 0 ]]; then
        cecho -c red -t "Required flags not found!"
        csm -h
        return
    fi
    for flag in "$@"; do
        case $flag in
            -s | --start) # Start
                cd $CSMDIR    
                if [[ "$(docker info 2>&1)" =~ "Cannot connect to the Docker daemon" ]]; then
                    cecho -c red -t "Docker daemon not running."
                    open -gj -a "docker"
                    gum spin -s line --title "Starting Docker daemon..." sleep 7
                fi
                docker compose up -d
                gum spin -s line --title "Starting container..." sleep 5
                dexec python3 csm_web/manage.py createtestdata
                source $(poetry env info --path)/bin/activate
                open http://localhost:8000/admin
                code .
                ;;
            -k | --kill) # Terminate
                cd $CSMDIR
                docker compose down 
                deactivate
                docker ps -a -q | xargs docker stop
                gum spin -s line --title "Stopping containers..." sleep 5
                docker ps -a -q | xargs docker rm
                gum spin -s line --title "Removing containers..." sleep 5
                ps ax | grep -i docker | egrep -iv 'grep|com.docker.vmnetd' | awk '{print $1}' | xargs kill
                cdir $curr
                ;;
            -h | --help) # Help
                echo "Usage: csm [OPTION]"
                echo "Options:"
                echo "  -s    Start CSM docker container"
                echo "  -t    Terminate all docker processes"
                echo "  -h    Display this help message"
                ;;
            *)
                cecho -c red -t "Invalid flag provided!"
                csm -h
                return
                ;;
        esac
    done
}
