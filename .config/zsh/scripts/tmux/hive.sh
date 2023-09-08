#!/bin/bash

# Set session and window names
SESSION="hive"

BASE="~/Documents/berkeley/Academics/su23/cs161/projects/proj1"
ACTIVATE_ONE="hive 5"
ACTIVATE_TWO="source .bashrc"
ACTIVATE_THREE="start"

SESSIONEXISTS=$(tmux list-sessions | grep $SESSION)


# Only create new session if it already doesn't exist
if [[ "$SESSIONEXISTS" = "" ]]; then
    # Initialize panes and windows
    tmux new -s $SESSION -d -c "$BASE"
    tmux split-window -h -t $SESSION. -d
    tmux split-window -v -t $SESSION.1 -d
    # Send activation command to all
    "$SCRIPTS"/tmux/tmux_sendall.sh $SESSION "$ACTIVATE_ONE"
    sleep 1
    "$SCRIPTS"/tmux/tmux_sendall.sh $SESSION "$ACTIVATE_TWO"
    "$SCRIPTS"/tmux/tmux_sendall.sh $SESSION "$ACTIVATE_THREE"
    # Switch to main window
    tmux select-pane -t $SESSION.0
fi

tmux switch -t $SESSION
