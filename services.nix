let unstable = import <nixos-unstable> { config.allowUnfree = true; }; in
{ config, ... }: {
	services.openssh.enable = true;
	services.kubo.enable = true;
	services.kubo.settings.Addresses.API = "/ip4/127.0.0.1/tcp/5001";
	services.kubo.package = unstable.kubo;
	users.users.samual.extraGroups = [ config.services.kubo.group ];
}
