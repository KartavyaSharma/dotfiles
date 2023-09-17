#!/bin/bash

# Set session and window names
SESSION="neetcode"

BASE="~/Documents/Code/neetcode/"

SESSIONEXISTS=$(tmux list-sessions | grep $SESSION)

if [[ "$SESSIONEXISTS" = "" ]]; then
    # Initialize panes and windows
    tmux new -s $SESSION -d -c "$BASE"
    tmux send-keys -t $SESSION.0 "cdir $BASE && v" Enter
fi

tmux switch -t $SESSION

