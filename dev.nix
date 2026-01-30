let unstable = import <nixos-unstable> { config.allowUnfree = true; }; in
{ pkgs, ... }: {
	programs.git.enable = true;
	programs.direnv.enable = true;
	boot.binfmt.registrations.wasm.magicOrExtension = "\\x00asm";
	boot.binfmt.registrations.wasm.mask = "\\xff\\xff\\xff\\xff";
	boot.binfmt.registrations.wasm.interpreter = "${pkgs.wasmtime}/bin/wasmtime run --";
	environment.variables.PROTOBUF_INCLUDE = "${pkgs.protobuf}/include";

	users.users.samual.packages = with pkgs; [
		deno remarshal gnumake wabt wasmtime gitui gcc cargo python3 unstable.nodejs_24 pnpm-shell-completion protobuf bun

		(pnpm.override {
			nodejs = unstable.nodejs_24;
			version = "10.28.2";
			hash = "sha256-r6mbC0s9EcHa0rRy+TGK4seGc4KXSd7VJ/ifCQcUeac=";
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
	];
}
