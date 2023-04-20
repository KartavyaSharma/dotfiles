#!/opt/homebrew/bin/bash

# Set session and window names
SESSION="game"

# Check if session exists
SESSIONEXISTS=$(tmux list-sessions | grep $SESSION)

if [[ "$SESSIONEXISTS" = "" ]]; then
    # Get sudo password
    GETPASS=$(gum input --password --placeholder "Enter sudo password")
    # Check validity of password
    curr_dir=$(pwd)
    cd && cd $SCRIPTS/utils/validate_pass/
    valid=$(python3 pass_check.py --password=$GETPASS)
    if [[ $valid = 1 ]]; then    
        # Initialize window
        tmux new -s $SESSION -d
        tmux send-keys -t $SESSION.0 " echo "${GETPASS}" | watch -n 0.1 sudo -S ifconfig awdl0 down" Enter
        # Send confirmation
        echo "Service daemon started."
    else
        echo "Incorrect sudo password."
    fi
    cd $curr_dir
else
    echo "Service already running"
    gum confirm "Kill service?" && tmux kill-session -t $SESSION
    SESSIONEXISTS=$(tmux list-sessions | grep $SESSION)
    if [[ "${SESSIONEXISTS}" != "" ]]; then
        echo "Aborted. Service still running."
    else
        echo "Service killed."
    fi
fi
