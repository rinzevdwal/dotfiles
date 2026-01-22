#!/bin/sh

export I3_SESSION_TYPE=xrdp

export DESKTOP_SESSION=i3
export XDG_CURRENT_DESKTOP=i3
export XDG_SESSION_TYPE=x11

if [ -r ~/.profile ]; then
  . ~/.profile
fi

exec /usr/local/bin/i3
