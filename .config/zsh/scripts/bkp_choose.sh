#!/opt/homebrew/bin/bash

# Create key-value pair for file to path map
declare -A FILES
FILES+=( ["ZSH Configuration File"]="~/.zshrc" ["Aliases"]="./.config/zsh/aliases.zsh" ["Scripts"]="~/.config/zsh/scripts/" ["TMUX Configuration"]="~/.tmux.conf" ["Starship Configuration"]="~/.config/starship.toml" ["Python & Brew Package Lists"]="~/.config/misc/" ["All"]="")

# Choose backup file
FILE_PICK=$(gum choose "ZSH Configuration File" "Aliases" "Scripts" "TMUX
Configuration" "Starship Configuration" "Python & Brew Package Lists")

gconf () {
    /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME "${@}"
}

gbkp () {
    curr_dir=$(pwd)
    cd
    gconf add "${1}" && gconf commit -m "Updated ${2}"
    gconf push
    cd $curr_dir
}

# Case selection
case "$FILE_PICK" in
    "Scripts"|"Python & Brew Package Lists") 
        curr_dir=$(pwd)
        cd ${FILES[$FILE_PICK]}
        case "$FILE_PICK" in
            "Scripts")
                gbkp . $FILE_PICK
                cd $curr_dir 
            ;;
            "Python & Brew Package Lists")

                # Update Brew Package List
                BREW_CONFIG="~/.config/misc/brew"
                CASKS="$BREW_CONFIG/brew_casks.txt"
                FORMULAE="$BREW_CONFIG/brew_formulae.txt"

                rm "$CASKS" "$FORMULAE"
                brew list --formulae >> $FORMULAE 
                brew list --casks >> $FORMULAE 

                # Update Python Package List
                cd ~/.config/misc/python
                pie bkp.py
                cd $curr_dir

                gbkp . $FILE_PICK

            ;;
            *) 
                echo "Impossible!"
            ;;
        esac
    ;;
    *)
        gbkp ${FILES[$FILE_PICK]} $FILE_PICK
    ;;
esac
