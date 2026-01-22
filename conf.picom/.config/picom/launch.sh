#!/bin/bash

# Check if a xrdp session is running
# if not then start picom else don't start picom
# picom doesn't work well with remote sessions.
if [ "$I3_SESSION_TYPE" != "xrdp" ]; then
    picom --daemon
fi
