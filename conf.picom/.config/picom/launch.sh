#!/usr/bin/env bash

# Check if we are in a remote xrdp session
# AND check if we are running inside a Virtual Machine.
# Picom is disabled in both cases to ensure performance.
# Picom doesn't work well with remote sessions and virtual machines.

VIRT_TYPE=$(systemd-detect-virt)

if [ "$I3_SESSION_TYPE" != "xrdp" ] && [ "$VIRT_TYPE" == "none" ]; then
    picom --daemon
fi
