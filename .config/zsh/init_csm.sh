#!/bin/bash

# Set session and window names
SESSION="csm_web"
W1="urls_fetch"

BASE="~/Documents/berkeley/extracurricular/clubs/CSM/repo"
MANAGED="$BASE/csm_web/csm_web/"
ACTIVATE="cdir $BASE && sc env/bin/activate && cdir $MANAGED"

SESSIONEXISTS=$(tmux list-sessions | grep $SESSION)

# Only create new session if it already doesn't exist
if [[ "$SESSIONEXISTS" = "" ]]; then
    # Initialize panes and windows
    tmux new -s $SESSION -d -c "$BASE"
    tmux split-window -h -t $SESSION. -d
    tmux split-window -v -t $SESSION.1 -d
    tmux new-window -t $SESSION -d -n $W1
    tmux split-window -v -t $SESSION:$W1 -d -p 35
    # Send activation commend to all
    ./tmux_sendall.sh $SESSION "$ACTIVATE"
    # Run pane/window specific command
    tmux send-keys -t $SESSION.1 "pie manage.py runserver" Enter
    tmux send-keys -t $SESSION:$W1.0 "pie manage.py show_urls" Enter
    tmux send-keys -t $SESSION:$W1.1 "git fetch" Enter
    tmux send-keys -t $SESSION.0 v Enter
    # Switch to main editor window
    tmux select-pane -t $SESSION.0
fi

tmux switch -t $SESSION
