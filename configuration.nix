{ config, pkgs, ... }:
let unstable = import <nixos-unstable> { config.allowUnfree = true; }; in
{
	imports = [ /etc/nixos/configuration.nix ];

	nix.gc = { automatic = true; options = "--delete-older-than 30d"; };
	nix.optimise.automatic = true;

	programs.git.enable = true;
	programs.zoxide.enable = true;
	programs.starship.enable = true;

	programs.fish.enable = true;
	programs.fish.shellAliases.nix-shell = /* sh */ "nix-shell --run fish";
	programs.fish.shellAliases.path = /* sh */ "echo $PATH | tr ' ' '\n'";
	programs.fish.shellAliases.cat = "bat";
	programs.fish.shellInit = /* fish */ ''
		atuin init fish --disable-up-arrow | source
	'';

	programs.neovim.enable = true;
	programs.neovim.package = unstable.neovim-unwrapped;
	programs.neovim.viAlias = true;
	programs.neovim.vimAlias = true;
	
	# programs.zsh.enable = true;
	programs.zsh.autosuggestions.enable = true;
	programs.zsh.autosuggestions.strategy = [ "completion" "match_prev_cmd" "history" ];
	programs.zsh.enableBashCompletion = true;
	programs.zsh.ohMyZsh.enable = true;
	programs.zsh.syntaxHighlighting.enable = true;
	programs.zsh.syntaxHighlighting.highlighters = [ "main" "brackets" "pattern" "cursor" "regexp" "root" "line" ];
	programs.zsh.enableCompletion = true;
	programs.zsh.shellAliases.nix-shell = /* sh */ "nix-shell --run zsh";
	programs.zsh.interactiveShellInit = /* sh */ ''
		old() {
			test -f $1~ && old $1~
			mv $1 $1~
		}
	'';
	programs.zsh.promptInit = /* sh */ ''
		# fpath=(${pkgs.zsh-completions}/share/zsh/site-functions $fpath)

		# if [[ ! -n $balvknxsxz3uij76r79lvwbe ]]; then
		# 	export balvknxsxz3uij76r79lvwbe=1
		# 	export PNPM_HOME=~/.local/share/pnpm
		# 	export PATH=$PNPM_HOME:~/.cargo/bin:$PATH
		# fi

		eval "$(atuin init zsh --disable-up-arrow)"
	'';
	programs.zsh.ohMyZsh.plugins = [
		"alias-finder" "aliases" "catimg" "colored-man-pages" "colorize" "common-aliases" "cp" "dircycle" "git"
		"git-auto-fetch" "history" "history-substring-search" "man" "qrcode" "rsync" "starship"
	];

	programs.tmux.enable = true;
	programs.tmux.newSession = true;
	programs.tmux.baseIndex = 1;
	programs.tmux.plugins = with pkgs.tmuxPlugins; [ sensible onedark-theme ];
	programs.tmux.terminal = "tmux-direct";

	programs.tmux.extraConfigBeforePlugins = /* tmux */ ''
		set -ag terminal-overrides ",xterm-256color:RGB"
		set -g mouse on
	'';

	services.openssh.enable = true;
	services.kubo.enable = true;
	services.kubo.settings.Addresses.API = "/ip4/127.0.0.1/tcp/5001";

	environment.systemPackages = with pkgs; [
		bat deno remarshal gnumake distrobox wget trash-cli fzf wabt wasmer file lzip nodejs_22 htop fastfetch tldr gron
		p7zip eza fq helix wl-clipboard-rs atuin fd zellij bat-extras.core gitui dust nixd xh jsonnet
		jsonnet-language-server yaml-language-server typescript-language-server simple-completion-language-server nixd
	];
	environment.variables.TERM = "xterm-256color";
	environment.variables.EDITOR = "hx";
	environment.shellAliases.tfa = /* sh */ ''tmux attach-session -t "$(tmux list-sessions | fzf | cut -d: -f1)"'';
	environment.shellAliases.du = /* sh */ "du --human-readable --max-depth=1";
	environment.shellAliases.ls = /* sh */ "eza --icons --classify --color --hyperlink --almost-all --sort=extension --group-directories-first";
	environment.shellAliases.ll = /* sh */ "ls --long --header --mounts --time-style='+%d/%m/%Y %H:%M' --git --git-repos";
	environment.shellAliases.df = /* sh */ "df --human-readable";
	environment.shellAliases.path = /* sh */ "echo $PATH | tr : '\n'";

	users.defaultUserShell = pkgs.fish;
	virtualisation.docker.enable = true;
	boot.binfmt.registrations.wasm.magicOrExtension = "\\x00asm";
	boot.binfmt.registrations.wasm.mask = "\\xff\\xff\\xff\\xff";
	boot.binfmt.registrations.wasm.interpreter = "${pkgs.wasmer}/bin/wasmer --";
	users.users.samual.extraGroups = [ "docker" config.services.kubo.group ];
	programs.direnv.enable = true;
	system.fsPackages = [ pkgs.sshfs ];
	security.pam.u2f.enable = true;
	programs.nix-ld.enable = true;
	users.users.samual.packages = with pkgs; [ gnupg unzip gcc ripgrep cargo python3 pnpm ];
}
