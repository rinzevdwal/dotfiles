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

## git

```sh
stow conf.git
```

add to `~/.gitconfig`

```sh
[include]
    path = ~/.git_aliases
```

## Application

```sh
sudo apt update && sudo apt install -y \
    xclip \
    btop \
    feh \
    fd-find \
```

```sh
# symbolic link for fdfind to fd
ln -s $(which fdfind) ~/.local/bin/fd
```

```sh
# i3 build dependencies
sudo apt update && sudo apt install -y \
    meson \
    ninja-build \
    libev-dev \
    libpango1.0-dev \
    libstartup-notification0-dev \
    libxcb-cursor-dev \
    libxcb-icccm4-dev \
    libxcb-keysyms1-dev \
    libxcb-randr0-dev \
    libxcb-shape0-dev \
    libxcb-xinerama0-dev \
    libxcb-xrm-dev \
    libxkbcommon-x11-dev \
    libyajl-dev
```

```sh
# optional i3 dependencies
sudo apt update && sudo apt install -y \
    dmenu \
    i3lock \
    asciidoc \
    i3status
```

```sh
# i3 installation
mkdir -p build && cd build
meson setup
ninja
sudo ninja install
```

```sh
# os tooling
sudo apt update && sudo apt install -y \
    feh \
    xrandr \
    arandr \
    autorandr \
    dunst \
    udisks2 \
    udiskie \
    flameshot
```

- kitty: kitty-0.42.2-x86_64
- bat: bat-v0.25.0-x86_64-unknown-linux-musl
- fzf: fzf-0.65.2-linux_amd64
- lazygit: lazygit_0.55.0_linux_x86_64
- lsd: lsd-v1.1.5-x86_64-unknown-linux-musl
- ripgrep: ripgrep-14.1.1-x86_64-unknown-linux-musl
- ripgrep-all: ripgrep_all-v0.10.10-x86_64-unknown-linux-musl
- starship: starship-x86_64-unknown-linux-musl
- btop: apt version
- fastfetch: fastfetch-linux-amd64 2.52.0
- picom: github.com/yshui/picom 2025 dec 9
- polybar: polybar-3.7.2
- rofi: rofi-2.0.0
- flameshot: v11.0.0
- i3lock-color: master Dec 12, 2025

## TODO

- auto-tiling
- mouse layout

## DE

- nm-applet
- pactl
