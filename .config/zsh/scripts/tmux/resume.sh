#!/bin/bash

# Set session and window names
SESSION="resume"

BASE="~/Documents/Code/resume"

SESSIONEXISTS=$(tmux list-sessions | grep $SESSION)

if [[ "$SESSIONEXISTS" = "" ]]; then
    # Initialize panes and windows
    tmux new -s $SESSION -d -c "$BASE"
    tmux send-keys -t $SESSION.0 "cdir $BASE && v resume_0122.tex" Enter
fi

tmux switch -t $SESSION

