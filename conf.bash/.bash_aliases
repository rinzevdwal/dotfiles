# custom aliases for bash

alias cwd='copy_working_directory'

# Use eza instead of ls
if which eza >/dev/null; then
    alias ll='eza -laaghF --icons'
    alias la='eza -aF --icons'
    alias l='eza -F --icons'
fi

# Use lsd instead of ls / eza
if which lsd >/dev/null; then
    alias ll='lsd -alFg'
    alias la='lsd -aF'
    alias l='lsd -F'
fi

if which bat >/dev/null; then
    alias cat='bat -pp'
fi

if which fastfetch >/dev/null; then
    alias fetch='fastfetch'
fi
