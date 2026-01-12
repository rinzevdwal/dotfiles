#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Get the list of monitors
# The output of polybar --list-monitors looks like:
# HDMI-1: 1920x1080+0+0 (primary)
# eDP-1: 1920x1080+1920+0

polybar --list-monitors | while read -r line; do
    # Extract the monitor name (everything before the colon)
    m=$(echo $line | cut -d":" -f1)
    
    # Check if the line contains the word "(primary)"
    if [[ $line == *"(primary)"* ]]; then
        echo "--- Launching primary bar on $m ---"
        MONITOR=$m polybar --reload main_bar &
    else
        echo "--- Launching secondary bar on $m ---"
        MONITOR=$m polybar --reload secondary_bar &
    fi
done

echo "Bars launched..."
