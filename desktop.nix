let unstable = import <nixos-unstable> { config.allowUnfree = true; }; in
{ pkgs, lib, ... }: {
	networking.hostName = lib.mkOverride 64 "samual-nixos";
	programs.partition-manager.enable = true;
	programs.kdeconnect.enable = true;
	services.avahi.enable = true;
	services.avahi.nssmdns4 = true;
	
	users.users.samual.packages = with pkgs; [
		firefox google-chrome krita wineWowPackages.stable kdePackages.filelight xorg.xkill thunderbird
		unstable.vscode unstable.obsidian alacritty libreoffice insomnia xournalpp neovide
	];

	environment.systemPackages = with pkgs; [ kdiskmark ];

	fonts.packages = with pkgs; [ cascadia-code nerd-fonts.symbols-only ];
	fonts.fontconfig.useEmbeddedBitmaps = true;
}
