#!/usr/bin/env bash

if ! command -v jq &>/dev/null; then
    echo "jq could not be found"
    exit 1
fi

# Swaps workspaces between two displays, focus stays on the current active display

DISPLAY_CONFIG="$(i3-msg -t get_outputs | jq -r '.[]|select(.active == true) |"\(.current_workspace)"')"
ACTIVE_WORKSPACE="$(i3-msg -t get_workspaces | jq -r '.[]|select(.focused == true) | "\(.name)"')"

IFS=$'\n'
for ROW in ${DISPLAY_CONFIG}; do
    i3-msg -- workspace --no-auto-back-and-forth "$ROW"
    i3-msg -- move workspace to output next
    sleep 0.1
done
sleep 0.1
i3-msg -- workspace --no-auto-back-and-forth "${ACTIVE_WORKSPACE}"
