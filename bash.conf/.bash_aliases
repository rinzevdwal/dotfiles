# custom aliases for bash

# Use eza instead of ls
if which eza >/dev/null; then
    alias ll='eza -laaghF --icons'
    alias la='eza -aF --icons'
    alias l='eza -F --icons'
fi

if which bat >/dev/null; then
    alias cat='bat -pp'
fi

