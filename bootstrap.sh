export NIX_CONFIG="experimental-features = nix-command flakes"

if [ ! -d "$HOME/.config/.git" ]; then
  if [ -d "$HOME/.config" ]; then
    mv "$HOME/.config" "$HOME/.config.bak"
  fi
  git clone -b nix https://github.com/radutomy/dotfiles "$HOME/.config"
fi

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
age -d -o "$HOME/.ssh/id_ed25519" "$HOME/.config/secrets/ssh_keys.age"
chmod 600 "$HOME/.ssh/id_ed25519"

if [ -d /etc/nixos ]; then
  nixos-rebuild switch --flake "$HOME/.config#$NIXOS_HOST" --impure
  hostname "$NIXOS_HOST"
fi

git -C "$HOME/.config" remote set-url origin git@github.com:radutomy/dotfiles.git

nvim --headless "+Lazy! sync" +qa
