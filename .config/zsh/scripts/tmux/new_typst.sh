#!/opt/homebrew/bin/bash

# Set Typst file name
FILE=$1
# Set session and window names
SESSION="typst-${FILE}"
# Set workspace location
WORKSPACE="./Documents/typst/workspace/"
# Activate command
ACTIVATE="cd && cdir $WORKSPACE"

SESSIONEXISTS=$(tmux list-session | grep $SESSION)

# Only create new session if it already doesn't exist
if [[  "$SESSIONEXISTS" = "" ]]; then
    # Initialize panes and windows
    tmux new -s $SESSION -d
    tmux split-window -h -t $SESSION. -d
    tmux split-window -v -t $SESSION.1 -d
    # Send activation command to all
    "$SCRIPTS"/tmux/tmux_sendall.sh $SESSION "$ACTIVATE"
    # Run pane/window specific commands
    tmux send-keys -t $SESSION.0 "touch ${FILE} && v ${FILE}" Enter
    tmux send-keys -t $SESSION.1 "typst --watch ${FILE}" Enter
    tmux send-keys -t $SESSION.2 "pdf ${FILE}.pdf" Enter
    # Switch to main editor window
    tmux select-pane -t $SESSION.0
fi

tmux switch -t $SESSION
