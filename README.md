# dotfiles

NixOS dotfiles managed with home-manager and flakes.

## Setup a new machine

```
NIX_CONFIG="experimental-features = nix-command flakes" nix run github:radutomy/dotfiles/nix
```

## Apply changes

```
home-manager switch --flake ~/.config
```

System-level changes:

```
nixos-rebuild switch --flake ~/.config --impure
```
