{ config, ... }:

let inherit (import <nixpkgs> {}) fetchFromGitHub; in

let fetchNixpkgs =
  { rev, sha256 ? "" }: import (fetchFromGitHub { owner = "NixOS"; repo = "nixpkgs"; inherit rev sha256; }) {}; in

let inherit (fetchNixpkgs {
  rev = "9d0c880cb3c00ccc7c792efa8acb0a2c2d14e4c8";
  sha256 = "Au8HuP4Q380EvBcVNrLiYnE1POyG2e4KRc8N52EvsO8=";
}) kubo; in

{
	services.openssh.enable = true;
	services.kubo.enable = true;
	services.kubo.settings.Addresses.API = "/ip4/127.0.0.1/tcp/5001";
	services.kubo.package = kubo;
	users.users.samual.extraGroups = [ config.services.kubo.group ];
}
