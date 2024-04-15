let unstable = import <nixos-unstable> { config.allowUnfree = true; }; in
{ config, pkgs, lib, ... }: {
	imports = [ /etc/nixos/configuration.nix ];
	nix.gc.automatic = true;
	nix.optimise.automatic = true;
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
	environment.shellAliases.nix-shell = "nix-shell --run zsh";
	environment.shellAliases.du = "du --human-readable --max-depth=1";
	environment.shellAliases.ls = "ls --color=auto --human-readable --classify --sort=extension";
	environment.shellAliases.df = "df --human-readable";
	environment.shellAliases.path = "echo $PATH | tr : '\n'";
	virtualisation.docker.enable = true;
	programs.tmux.enable = true;
	programs.tmux.newSession = true;
	programs.tmux.baseIndex = 1;
	programs.tmux.plugins = with pkgs.tmuxPlugins; [ sensible onedark-theme ];

	programs.tmux.extraConfigBeforePlugins = ''
		set -ag terminal-overrides ",xterm-256color:RGB"
		set -g mouse on
	'';

	boot.binfmt.registrations.wasm.magicOrExtension = "\\x00asm";
	boot.binfmt.registrations.wasm.mask = "\\xff\\xff\\xff\\xff";
	boot.binfmt.registrations.wasm.interpreter = "/run/current-system/sw/bin/wasmer";
	users.users.samual.extraGroups = [ "docker" config.services.kubo.group ];
	services.kubo.enable = true;
	services.kubo.settings.Addresses.API = "/ip4/127.0.0.1/tcp/5001";
	programs.direnv.enable = true;
	system.fsPackages = [ pkgs.sshfs ];
	programs.zsh.syntaxHighlighting.highlighters = [ "main" "brackets" ];
	security.pam.u2f.enable = true;
	programs.nix-ld.enable = true;

	programs.zsh.promptInit = ''
		if [[ ! -n $balvknxsxz3uij76r79lvwbe ]]; then
			export balvknxsxz3uij76r79lvwbe=1
			export PNPM_HOME=~/.local/share/pnpm
			export PATH=$PNPM_HOME:~/.cargo/bin:$PATH
		fi

		eval "$(atuin init zsh --disable-up-arrow)"
	'';

	programs.zsh.ohMyZsh.plugins = [
		"alias-finder" "aliases" "catimg" "colored-man-pages" "colorize" "common-aliases" "cp" "dircycle" "git"
		"git-auto-fetch" "history" "history-substring-search" "man" "qrcode" "rsync" "starship"
	];

	environment.systemPackages = with pkgs; [
		starship bat deno remarshal gnumake distrobox wget trash-cli fzf wabt wasmer file lzip unstable.atuin nodejs_20
		btop fastfetch tldr gron
	];
	
	users.users.samual.packages = with pkgs; [ gnupg unzip gcc ripgrep cargo ];
}
