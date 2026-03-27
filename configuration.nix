{ pkgs, ... }:
let unstable = import <nixos-unstable> { config.allowUnfree = true; }; in
{
	imports = [ /etc/nixos/configuration.nix ];

	nix.gc = { automatic = true; options = "--delete-older-than 30d"; };
	nix.optimise.automatic = true;

	programs.zoxide.enable = true;
	programs.starship.enable = true;

	# Fish
		programs.fish.enable = true;

		programs.fish.shellAliases = {
			nix-shell = /* sh */ "nix-shell --run fish";
			list-path = /* sh */ "echo $PATH | tr ' ' '\n'";
			cat = "bat";
		};

		programs.fish.interactiveShellInit = /* fish */ ''
			atuin init fish --disable-up-arrow | source

			function mkcd --argument-names folder --description 'Make a directory and change to it'
				mkdir $folder
				cd $folder
			end

			# Git
			abbr --add gspp 'git stash && begin; git pull; git stash pop; end'
			abbr --command git unstage 'restore --staged'
			abbr --command git diff-staged 'diff --staged'
			abbr --command git diff-stage 'diff --staged'
			abbr --command git ds 'diff --staged'
			abbr --add gds 'git diff --staged'
			abbr --command git stage-diff 'diff --staged'
			abbr --command git sd 'diff --staged'
			abbr --command git add-patch 'add --patch'
			abbr --command git ap 'add --patch'
			abbr --command git remotes 'remote --verbose'
			abbr --command git branches 'branch --verbose'
			abbr --command git stash-staged 'stash push --staged'
			abbr --command git commmit commit
			abbr --command git stauts status
			abbr --add gap 'git add --patch'

			abbr --command docker run 'run --interactive --tty --rm'
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
	programs.zsh.shellAliases.list-path = /* sh */ "echo $PATH | tr : '\n'";
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
	programs.tmux.plugins = with pkgs.tmuxPlugins; [ sensible ];
	programs.tmux.terminal = "tmux-direct";

	programs.tmux.extraConfigBeforePlugins = /* tmux */ ''
		set -ag terminal-overrides ",xterm-256color:RGB"
		set -g mouse on
	'';

	boot.kernel.sysctl."net.core.rmem_max" = 7500000;
	boot.kernel.sysctl."net.core.wmem_max" = 7500000;

	environment.systemPackages = with pkgs; [ atuin zellij ];
	environment.variables.TERM = "xterm-256color";
	environment.variables.EDITOR = "hx";
	environment.variables.IPFS_GATEWAY = "http://localhost:8080";
	environment.shellAliases.tfa = /* sh */ ''tmux attach-session -t "$(tmux list-sessions | fzf | cut -d: -f1)"'';
	environment.shellAliases.du = /* sh */ "du --human-readable --max-depth=1";
	environment.shellAliases.ls = /* sh */ "eza --icons --classify --color --hyperlink --almost-all --sort=extension --group-directories-first --binary";
	environment.shellAliases.ll = /* sh */ "ls --long --header --mounts --time-style='+%d/%m/%Y %H:%M' --git --git-repos";
	environment.shellAliases.df = /* sh */ "df --human-readable";

	users.defaultUserShell = pkgs.fish;
	virtualisation.docker.enable = true;
	boot.tmp.useTmpfs = true;
	users.users.samual.extraGroups = [ "docker" ];
	system.fsPackages = [ pkgs.sshfs ];
	security.pam.u2f.enable = true;
	programs.nix-ld.enable = true;
	programs.nix-ld.libraries = with pkgs; [ libxcb dbus.lib gtk3 gdk-pixbuf cairo glib webkitgtk_4_1 libsoup_3 ];

	users.users.samual.packages = with pkgs; [
		bat distrobox wget trash-cli fzf file lzip htop fastfetch tldr gron p7zip eza fq unstable.helix fd bat-extras.core
		dust xh go-jsonnet gnupg unzip ripgrep btrfs-progs smartmontools glow hyperfine asciidoctor micro dash btop pandoc
		jq
	];
}
