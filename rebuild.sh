#!sh
set -ex
sudo nixos-rebuild switch --upgrade-all -I nixos-config=configuration.nix
