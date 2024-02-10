{ config, pkgs, lib, ... }: {
	imports = [ /etc/nixos/configuration.nix ];
	networking.hostName = lib.mkForce "samual-nixos";
	nix.gc.automatic = true;
	programs.git.enable = true;
	programs.neovim.enable = true;
	programs.neovim.defaultEditor = true;
	programs.neovim.viAlias = true;
	programs.neovim.vimAlias = true;
	programs.zsh.autosuggestions.enable = true;
	programs.zsh.autosuggestions.strategy = [ "completion" "match_prev_cmd" "history" ];
	programs.zsh.enable = true;
	programs.zsh.enableBashCompletion = true;
	programs.zsh.ohMyZsh.enable = true;
	programs.zsh.syntaxHighlighting.enable = true;
	services.openssh.enable = true;
	users.defaultUserShell = pkgs.zsh;
	environment.shellAliases.tfa = ''tmux attach-session -t "$(tmux list-sessions | fzf | cut -d: -f1)"'';
	environment.shellAliases."nix-shell" = "nix-shell --run zsh";
	environment.shellAliases.du = "du --human-readable --max-depth=1";
	environment.shellAliases.ls = "ls --color=auto --human-readable --classify --sort=extension";
	environment.shellAliases.df = "df --human-readable";
	virtualisation.docker.enable = true;
	programs.partition-manager.enable = true;
	programs.kdeconnect.enable = true;
	programs.tmux.enable = true;
	programs.tmux.newSession = true;
	boot.binfmt.registrations.wasm.magicOrExtension = "\\x00asm";
	boot.binfmt.registrations.wasm.mask = "\\xff\\xff\\xff\\xff";
	boot.binfmt.registrations.wasm.interpreter = "/run/current-system/sw/bin/wasmer";
	users.users.samual.extraGroups = [ "docker" config.services.kubo.group ];
	security.pam.u2f.enable = true;
	services.kubo.enable = true;
	services.kubo.settings.Addresses.API = "/ip4/127.0.0.1/tcp/5001";

	programs.zsh.interactiveShellInit = ''
		export PNPM_HOME=~/.local/share/pnpm
		export PATH=$PNPM_HOME:$PATH
	'';

	programs.zsh.ohMyZsh.plugins = [
		"alias-finder" "aliases" "catimg" "colored-man-pages" "colorize" "common-aliases" "cp" "dircycle" "git"
		"git-auto-fetch" "history" "history-substring-search" "last-working-dir" "man" "qrcode" "rsync" "starship"
	];

	environment.systemPackages = with pkgs; [
		starship bat deno remarshal gnumake distrobox wget trash-cli fzf wabt wasmer file
	];
	
	users.users.samual.packages = with pkgs; [
		firefox nodejs_20 google-chrome krita direnv gnupg wineWowPackages.stable libsForQt5.filelight xorg.xkill
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
