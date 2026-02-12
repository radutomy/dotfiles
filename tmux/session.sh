#!/bin/sh
tmux attach 2>/dev/null && exit

if uname -r | grep -q orbstack; then
  HOST_WIN=macos HOST_CMD=mac
else
  HOST_WIN=pwsh HOST_CMD=pwsh.exe
fi

tmux new-session -d -s main -n ide
tmux new-window -n main
tmux new-window -n term
tmux split-window -v
tmux select-pane -U
tmux new-window -n aux
tmux split-window -v
tmux select-pane -U
tmux new-window -n "$HOST_WIN"
tmux send-keys -t "$HOST_WIN" "$HOST_CMD" Enter
sleep 0.5
tmux send-keys -t "$HOST_WIN" "cd && clear" Enter
tmux select-window -t 0
tmux attach
