let unstable = import <nixos-unstable> { config.allowUnfree = true; }; in
{ pkgs, ... }: {
	programs.git.enable = true;
	programs.direnv.enable = true;
	boot.binfmt.registrations.wasm.magicOrExtension = "\\x00asm";
	boot.binfmt.registrations.wasm.mask = "\\xff\\xff\\xff\\xff";
	boot.binfmt.registrations.wasm.interpreter = "${pkgs.wasmtime}/bin/wasmtime run --";
	environment.variables.PROTOBUF_INCLUDE = "${pkgs.protobuf}/include";

	users.users.samual.packages = with pkgs; [
		deno remarshal gnumake wabt wasmtime gitui gcc cargo python3 unstable.nodejs_24 pnpm-shell-completion protobuf
		bun checkbashisms

		(pnpm.override {
			nodejs = unstable.nodejs_24;
			version = "10.33.0";
			hash = "sha256-v8wby60nmxOlFsRGp1s8WLaQS0XVehlRQRAV5Qt1GoA=";
		})

		# Language Servers
		nixd
		jsonnet-language-server
		yaml-language-server
		typescript-language-server
		simple-completion-language-server
		tailwindcss-language-server
		emmet-language-server
		wasm-language-tools
		rust-analyzer
		vscode-json-languageserver
		vscode-langservers-extracted
		dockerfile-language-server
		unstable.protols
		taplo
	];
}
