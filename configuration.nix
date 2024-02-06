{ config, pkgs, ... }: {
	boot.loader.efi.canTouchEfiVariables = true;
	boot.loader.systemd-boot.enable = true;
	console.keyMap = "uk";
	environment.systemPackages = with pkgs; [ starship ];
	hardware.pulseaudio.enable = false;
	i18n.defaultLocale = "en_GB.UTF-8";
	i18n.extraLocaleSettings.LC_ADDRESS = "en_GB.UTF-8";
	i18n.extraLocaleSettings.LC_IDENTIFICATION = "en_GB.UTF-8";
	i18n.extraLocaleSettings.LC_MEASUREMENT = "en_GB.UTF-8";
	i18n.extraLocaleSettings.LC_MONETARY = "en_GB.UTF-8";
	i18n.extraLocaleSettings.LC_NAME = "en_GB.UTF-8";
	i18n.extraLocaleSettings.LC_NUMERIC = "en_GB.UTF-8";
	i18n.extraLocaleSettings.LC_PAPER = "en_GB.UTF-8";
	i18n.extraLocaleSettings.LC_TELEPHONE = "en_GB.UTF-8";
	i18n.extraLocaleSettings.LC_TIME = "en_GB.UTF-8";
	imports = [ /etc/nixos/hardware-configuration.nix ];
	networking.hostName = "samual-nixos";
	networking.networkmanager.enable = true;
	nix.gc.automatic = true;
	nixpkgs.config.allowUnfree = true;
	programs.git.enable = true;
	programs.neovim.defaultEditor = true;
	programs.neovim.enable = true;
	programs.neovim.viAlias = true;
	programs.neovim.vimAlias = true;
	programs.zsh.autosuggestions.enable = true;
	programs.zsh.autosuggestions.strategy = [ "completion" "match_prev_cmd" "history" ];
	programs.zsh.enable = true;
	programs.zsh.enableBashCompletion = true;
	programs.zsh.ohMyZsh.enable = true;
	programs.zsh.syntaxHighlighting.enable = true;
	security.rtkit.enable = true;
	services.openssh.enable = true;
	services.pipewire.alsa.enable = true;
	services.pipewire.alsa.support32Bit = true;
	services.pipewire.enable = true;
	services.pipewire.pulse.enable = true;
	services.printing.enable = true;
	services.vscode-server.enable = true;
	services.xserver.desktopManager.plasma5.enable = true;
	services.xserver.displayManager.sddm.enable = true;
	services.xserver.enable = true;
	services.xserver.layout = "gb";
	services.xserver.videoDrivers = [ "nvidia" ];
	services.xserver.xkbVariant = "";
	sound.enable = true;
	system.autoUpgrade.allowReboot = true;
	system.autoUpgrade.enable = true;
	system.stateVersion = "23.11";
	time.timeZone = "Europe/London";
	users.defaultUserShell = pkgs.zsh;
	users.users.samual.description = "Samual Norman";
	users.users.samual.extraGroups = [ "networkmanager" "wheel" ];
	users.users.samual.isNormalUser = true;
	users.users.samual.packages = with pkgs; [ firefox kate vscode nodejs_20];

	programs.zsh.interactiveShellInit = ''
		export PNPM_HOME=~/.local/share/pnpm
		export PATH=$PNPM_HOME:$PATH
	'';

	programs.zsh.ohMyZsh.plugins = [
		"alias-finder" "aliases" "catimg" "colored-man-pages" "colorize" "common-aliases" "cp" "dircycle" "git"
		"git-auto-fetch" "history" "history-substring-search" "last-working-dir" "man" "qrcode" "rsync" "starship"
	];
}
