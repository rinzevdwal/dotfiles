#!/usr/bin/env bash

# Use flock/mutex to prevent script race conditions (multiple instance running or half closed by script)
# Use nonblock because there is no need to restart polybar again after a restart.
# Use close because the lock should not be hold by polybar running as a daemon.
flock --nonblock --close ~/.config/polybar/lockfile.lock ~/.config/polybar/_launch.sh || \
    echo "Error: Another instance of $(basename "$0") is already running." >&2
