#!/usr/bin/env bash

TEMP_DIR=/tmp/i3/cheat-sheet

rm -rf $TEMP_DIR
mkdir -p $TEMP_DIR

pandoc ~/dotfiles/keybindings.md \
    --standalone \
    --css="$HOME/.config/i3/cheat-sheet/theme.css" \
    --pdf-engine=weasyprint \
    --output=$TEMP_DIR/keybindings.pdf 

zathura $TEMP_DIR/keybindings.pdf \
    --config-dir=$HOME/.config/i3/cheat-sheet/ \
    --data-dir=$TEMP_DIR \
    --cache-dir=$TEMP_DIR
