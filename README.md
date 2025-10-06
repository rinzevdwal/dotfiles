# Dotfiles

My dotfiles managed by gnu stow.

## Preconditions

Create some folder to prevent them being symlinked for other application.

```sh
mkdir -p ~/.local/share/man/man1
mkdir -p ~/.local/share/man/man5
mkdir -p ~/.local/share/fonts
mkdir -p ~/.local/share/icons
```

## Stow

### Install

```sh
sudo apt Install stow
```

### Stow package

```sh
cd ~/dotfiles
stow <package>
```

### Unstow package

```sh
cd ~/dotfiles
stow -D <package>
```

## Fonts

```sh
stow fonts
fc-cache -fv # update the font cache.
```

## bat

```sh
stow conf.bat
bat cache --build # rebuild bat's cache to load the theme
```

## Application

```sh
sudo apt update && sudo apt install -y \
    xclip \
    btop \
    feh \
```

```sh
# i3 build dependencies
sudo apt update && sudo apt install -y \
    meson \
    ninja-build \
    libev-dev \
    libxkbcommon-x11-dev \
    libpango1.0-dev \
    libstartup-notification0-dev \
    libxcb-cursor-dev \
    libxcb-keysyms1-dev \
    libxcb-xrm-dev \
    libyajl-dev \
```

```sh
# optional i3 dependencies
sudo apt update && sudo apt install -y \
    dmenu \
    i3lock \
    asciidoc \
    i3status
```

- kitty: kitty-0.42.2-x86_64
- bat: bat-v0.25.0-x86_64-unknown-linux-musl
- fzf: fzf-0.65.2-linux_amd64
- lazygit: lazygit_0.55.0_linux_x86_64
- lsd: lsd-v1.1.5-x86_64-unknown-linux-musl
- ripgrep: ripgrep-14.1.1-x86_64-unknown-linux-musl
- starship: starship-x86_64-unknown-linux-musl
- btop: apt version
- fastfetch: fastfetch-linux-amd64 2.52.0

## TODO

- i3 config / split up?
- i3lock color
- picom
- rofi
- polybar
- xborder
- auto-tiling
- screenshots
- notifications

## DE

- i3status
- feh
- i3lock-fancy
- dmenu
- nm-applet
- pactl
