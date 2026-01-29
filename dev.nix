{ pkgs, ... }: {
	programs.git.enable = true;
	programs.direnv.enable = true;
	boot.binfmt.registrations.wasm.magicOrExtension = "\\x00asm";
	boot.binfmt.registrations.wasm.mask = "\\xff\\xff\\xff\\xff";
	boot.binfmt.registrations.wasm.interpreter = "${pkgs.wasmtime}/bin/wasmtime run --";

	users.users.samual.packages = with pkgs; [
		deno remarshal gnumake wabt wasmtime gitui gcc cargo python3 unstable.nodejs_24 pnpm-shell-completion

		(pnpm.override {
			nodejs = unstable.nodejs_24;
			version = "10.27.0";
			hash = "sha256-08fD0S2H0XfjLwF0jVmU+yDNW+zxFnDuYFMMN0/+q7M=";
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
		dockerfile-language-server
	];
}
