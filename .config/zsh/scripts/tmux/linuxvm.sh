#!/bin/bash

# Get current session
CURR=$(tmux display-message -p '#S')

# Set session and window names
SESSION="linuxvm"

RESOURCE_NAME="linux_system_admin_decal"
VM_NAME="linux-sys-admin"

START_VM="az vm start --name $VM_NAME -g $RESOURCE_NAME"
STOP_VM="az vm stop --name $VM_NAME -g $RESOURCE_NAME"
DE_VM="az vm deallocate --name $VM_NAME -g $RESOURCE_NAME"
PREV_SESH="tmux switch -t $CURR"
KILL_SESH="tmux kill-session -t $SESSION"
LOGINTO_VM="$START_VM && ssh -i $LVMKEY kurt@$LVMIP && $PREV_SESH && $STOP_VM && $DE_VM && $KILL_SESH"

SESSIONEXISTS=$(tmux list-sessions | grep $SESSION)

# Only create new session if it already doesn't exist
if [[ "$SESSIONEXISTS" = "" ]]; then
    # Initialize new window
    tmux new -s $SESSION -d -c "~"
    tmux switch -t $SESSION
    tmux send-keys -t $SESSION "$LOGINTO_VM" C-m
else
    tmux switch -t $SESSION
fi
