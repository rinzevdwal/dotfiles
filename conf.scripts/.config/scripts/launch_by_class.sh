#!/bin/bash

# Usage: ./launch_check.sh <TARGET_CLASS> <COMMAND>
# Example: ./launch_check.sh "code" "code"

TARGET_CLASS=$1
LAUNCH_CMD=$2
FOUND=false

# 1. Get all window IDs from the root window property _NET_CLIENT_LIST
# We use xprop to get the list, then clean it up to get just the hex IDs
WINDOW_IDS=$(xprop -root _NET_CLIENT_LIST | cut -d'#' -f2 | tr ',' '\n')

for ID in $WINDOW_IDS; do
    # 2. Check the WM_CLASS for each window ID
    # We strip quotes and search for the target class
    CLASS=$(xprop -id "$ID" WM_CLASS 2>/dev/null)
    
    if echo "$CLASS" | grep -iq "$TARGET_CLASS"; then
        FOUND=true
        break
    fi
done

# 3. Decision logic
if [ "$FOUND" = true ]; then
    echo "Window with class '$TARGET_CLASS' is already running."
else
    echo "Class '$TARGET_CLASS' not found. Launching $LAUNCH_CMD..."
    # 1. Pass the class to the app (so it's found next time)
    # 2. Redirect all output (stdout/stderr) to /dev/null
    # 3. Use 'disown' so the script can close without killing the app
    ($LAUNCH_CMD --class "$TARGET_CLASS" > /dev/null 2>&1 & disown)
    
    echo "Launch command sent. Script exiting."
    exit 0
fi
