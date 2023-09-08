#!/opt/homebrew/bin/bash

# Create key-value pair for file to path map
declare -A FILES
FILES+=( ["ZSH Configuration File"]="./.zshrc" ["Aliases"]="./.config/zsh/aliases.zsh" ["Scripts"]="./.config/zsh/scripts" ["TMUX Conf"]="./.tmux.conf" ["Starship Configuration"]="./.config/starship.toml" ["Python & Brew Package Lists"]="./.config/misc" ["Kitty"]="./.config/kitty/kitty.conf" ["All"]="")

# Create array of associative keys for $(gum choose)
declare -a FILE_OPTS 
for FILE in "${!FILES[@]}"; do
    FILE_OPTS+=("$FILE")
done

echo "Choose file for backup:"
# Choose backup file
FILE_PICK=$(gum choose "${FILE_OPTS[@]}")

gconf () {
    /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME "${@}"
}

git_backup () {
    files=("$@")
    curr_dir=$(pwd)
    cd
    gconf add "${files[@]}" && gconf commit # -m "Updated ${2}"
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

    files=($CASKS $FORMULAE $PYTHON_CONFIG)

    git_backup ${files[@]}

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
                    $SCRIPTS/utils/echo/echo.sh -c yellow -t "This only backs up .sh scripts 1 level deep in the scripts directory."
                    glob_path="${FILES[$FILE_PICK]}"
                    # Add all files in $SCRIPTS
                    declare -a script_files
                    for FILE in *.sh; do
                        script_files+=("$glob_path/$FILE");
                    done
                    # Add all files from dirs
                    for DIR in */; do
                        dir_path="$glob_path/$DIR"
                        cd && cd "${dir_path}"
                        for FILE in *.sh; do
                            script_files+=("$dir_path$FILE")
                        done
                    done
                    # echo ${script_files[@]}
                    git_backup ${script_files[@]} #$FILE_PICK
                    cd $curr_dir 
                ;;
                "Python & Brew Package Lists")
                    pybrew_backup
                    cd $curr_dir
                ;;
            esac
        ;;
        *)
            files=(${FILES[$FILE_PICK]})
            git_backup ${files[@]} #$FILE_PICK
        ;;
    esac
    gconf push
else
    echo "No selection. Exiting..."
fi
