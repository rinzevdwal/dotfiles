# Dotfiles

My dotfiles managed by gnu stow.

## Preconditions

Create some folder to prevent them being symlinked for other application.

```sh
mkdir -p ~/.local/bin
mkdir -p ~/.local/share
mkdir -p ~/.local/share/man
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
