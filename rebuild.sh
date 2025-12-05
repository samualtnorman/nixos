#!/bin/sh
set -ex

if [ -e custom.nix ]
then
	configFile=custom.nix
else
	configFile=configuration.nix
fi

sudo nixos-rebuild switch --upgrade-all -I nixos-config=$configFile $@
