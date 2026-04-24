# Dotfiles

## Installing dotfiles

`./install`

## Installing NixOS

**Apply disk layout and mount (will erase all data):**

`nix run .#disko -- --mode destroy,format,mount --flake .#hostname`

**Install NixOS:**

`sudo nixos-install --flake .#hostname`
