export NIX_CONFIG="experimental-features = nix-command flakes"

if [ ! -d "$HOME/.config/.git" ]; then
  if [ -d "$HOME/.config" ]; then
    mv "$HOME/.config" "$HOME/.config.bak"
  fi
  git clone -b nix https://github.com/radutomy/dotfiles "$HOME/.config"
fi

chmod 775 "$HOME"
chown root:users "$HOME"

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
age -d -o "$HOME/.ssh/id_ed25519" "$HOME/.config/secrets/ssh_keys.age"
chmod 600 "$HOME/.ssh/id_ed25519"

nix run home-manager/release-25.11 -- switch --flake "$HOME/.config"

if [ -d /etc/nixos ]; then
  nixos-rebuild switch --flake "$HOME/.config" --impure
fi

git -C "$HOME/.config" remote set-url origin git@github.com:radutomy/dotfiles.git

nvim --headless "+Lazy! sync" +qa
