{
  description = "Spage daemon";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = [
            pkgs.go_1_23 # Or your preferred Go version
            pkgs.golangci-lint
            pkgs.pre-commit
            pkgs.protobuf # Protocol buffer compiler
            # Add other Go tools or dependencies here if needed, e.g.:
            pkgs.gopls
            pkgs.delve
          ];

          # Disable hardening for cgo
          hardeningDisable = [ "all" ];
        };
      });
}
