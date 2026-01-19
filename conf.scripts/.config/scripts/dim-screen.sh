#!/usr/bin/env bash

# Target dim level (0-100, where 100 = full brightness)
DIM_LEVEL=30

# Fade duration in milliseconds
FADE_DURATION=4000

# Number of steps for the fade
STEPS=100

# Get all connected outputs
OUTPUTS=$(xrandr | grep " connected" | awk '{print $1}')

# Function to restore brightness
restore_brightness() {
    for output in $OUTPUTS; do
        xrandr --output "$output" --brightness 1.0
    done
}

# Set trap to restore brightness on exit
trap restore_brightness EXIT

# Calculate delay between steps in seconds
DELAY=$(awk "BEGIN {print $FADE_DURATION / $STEPS / 1000}")

# Gradually dim all outputs
for ((i=0; i<=STEPS; i++)); do
    # Calculate current brightness (100 down to DIM_LEVEL)
    CURRENT=$((100 - ((100 - DIM_LEVEL) * i / STEPS)))
    BRIGHTNESS=$(awk "BEGIN {print $CURRENT / 100}")
    
    for output in $OUTPUTS; do
        xrandr --output "$output" --brightness "$BRIGHTNESS"
    done
    
    sleep "$DELAY"
done

# If we reach here, stay dim until xss-lock kills us when locker starts
# (trap will NOT run because process is replaced by locker)
sleep infinity
