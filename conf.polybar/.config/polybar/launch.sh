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
        echo "--- Launching bars + tray on $m ---"
        MONITOR=$m polybar --reload bar_menu &
        MONITOR=$m polybar --reload bar_i3 &
        MONITOR=$m polybar --reload bar_date &
        MONITOR=$m polybar --reload bar_stats &
        MONITOR=$m polybar --reload bar_tray &
    else
        echo "--- Launching bars on $m ---"
        MONITOR=$m polybar --reload bar_menu &
        MONITOR=$m polybar --reload bar_i3 &
        MONITOR=$m polybar --reload bar_date &
        MONITOR=$m polybar --reload bar_stats &
    fi
done

echo "Bars launched..."
