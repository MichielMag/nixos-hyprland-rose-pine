#!/bin/bash

WAYBAR_ID="$1"
WAYBAR_PID=$(pgrep -fa "waybar -b $WAYBAR_ID" | awk '{print $1}')
kill -SIGUSR1 "$WAYBAR_PID"