#!/bin/bash

if [[ -z $1 ]]; then
    current=$(tmux display -p "#S")
    echo "usage: tmux-sendall SESSION [COMMAND]"
    if [[ -n $current ]]; then
        echo "current session: $current"
    fi
    exit 1
else
    echo "$1"
    session="$1"
fi

if [[ -n $2 ]]; then
    message="$2"
else
    read -p "send cmd to session $session$ " message
    if [[ -z $message ]]; then exit 1; fi
fi

function sendwindow() {
    # $1=target, $2=command
    tmux setw -t $1 synchronize-panes
    tmux send-keys -lt "$1" "$2"
    tmux send-keys -t "$1" "Enter"
    tmux setw -t $1 synchronize-panes off
}

export -f sendwindow
tmux list-windows -t $session | cut -d: -f1 | xargs -I{} bash -c "sendwindow '$session:{}' '$message'"
