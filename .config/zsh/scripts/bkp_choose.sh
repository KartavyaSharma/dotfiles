#!/opt/homebrew/bin/bash

# Create key-value pair for file to path map
declare -A FILES
FILES+=( ["ZSH Configuration File"]="./.zshrc" ["Aliases"]="./.config/zsh/aliases.zsh" ["Scripts"]="./.config/zsh/scripts/" ["TMUX Conf"]="./.tmux.conf" ["Starship Configuration"]="./.config/starship.toml" ["Python & Brew Package Lists"]="./.config/misc/" ["All"]="")

echo "Choose file for backup:"
# Choose backup file
FILE_PICK=$(gum choose "ZSH Configuration File" "Aliases" "Scripts" "TMUX Conf" "Starship Configuration" "Python & Brew Package Lists")

gconf () {
    /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME "${@}"
}

git_backup () {
    curr_dir=$(pwd)
    cd
    gconf add "${1}" && gconf commit -m "Updated ${2}"
    cd $curr_dir
}

pybrew_backup () {
    prev_dir=$(pwd)
    cd

    # Update Brew Package List
    BREW_CONFIG="./.config/misc/brew"
    CASKS="$BREW_CONFIG/brew_casks.txt"
    FORMULAE="$BREW_CONFIG/brew_formulae.txt"

    rm "${CASKS}" "${FORMULAE}"
    brew list --formulae >> "${FORMULAE}"
    brew list --casks >> "${CASKS}"

    # Update Python Package List
    PYTHON_CONFIG="./.config/misc/python"
    pip3 freeze > "$PYTHON_CONFIG/python.txt"

    git_backup "${CASKS}" $FILE_PICK
    git_backup "${FORMULAE}" $FILE_PICK
    git_backup "$PYTHON_CONFIG/python.txt" $FILE_PICK

    cd $prev_dir
}

if [[ $FILE_PICK ]]; then
    # Case selection
    case "$FILE_PICK" in
        "Scripts"|"Python & Brew Package Lists") 
            curr_dir=$(pwd)
            cd
            cd "${FILES[$FILE_PICK]}"
            case "$FILE_PICK" in
                "Scripts")
                    glob_path="${FILES[$FILE_PICK]}"
                    declare -a script_files
                    for FILE in *; do
                        script_files+=("$glob_path/$FILE");
                    done
                    git_backup ${script_files[@]} $FILE_PICK
                    cd $curr_dir 
                ;;
                "Python & Brew Package Lists")
                    pybrew_backup
                    cd $curr_dir
                ;;
            esac
        ;;
        *)
            git_backup ${FILES[$FILE_PICK]} $FILE_PICK
        ;;
    esac
    gconf push
else
    echo "No selection. Exiting..."
fi
