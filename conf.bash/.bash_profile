# include .bashrc if it exists
if [ -f "$HOME/.profile" ]; then
    . "$HOME/.profile"
fi
