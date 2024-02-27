{ config, pkgs, lib, ... }: {
	programs.partition-manager.enable = true;
	programs.kdeconnect.enable = true;
	security.pam.u2f.enable = true;
	services.avahi.enable = true;
	services.avahi.nssmdns = true;
	
	users.users.samual.packages = with pkgs; [
		firefox google-chrome krita wineWowPackages.stable libsForQt5.filelight xorg.xkill nerdfonts thunderbird
	];

	services.udev.extraRules = ''
		ACTION=="remove",\
		ENV{ID_BUS}=="usb",\
		ENV{ID_MODEL_ID}=="0407",\
		ENV{ID_VENDOR_ID}=="1050",\
		ENV{ID_VENDOR}=="Yubico",\
		RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
	'';
}