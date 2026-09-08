{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    flake-utils.url = "github:numtide/flake-utils";
    liquido-nix.url = "github:mdcge/liquido-nix";
  };

  outputs = { self, nixpkgs, flake-utils, liquido-nix, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        ratpac = liquido-nix.packages.${system}.liquido-ratpac;
      in {
        devShells.default = pkgs.mkShell {
          inputsFrom = [ ratpac ];
          packages = [ ratpac pkgs.cmake pkgs.pkg-config ];
          shellHook = ''
            export CMAKE_PREFIX_PATH=${ratpac}:${pkgs.root}:$CMAKE_PREFIX_PATH
          '' + pkgs.lib.optionalString pkgs.stdenv.isDarwin ''
            export SDKROOT="$(echo $NIX_CFLAGS_COMPILE | tr ' ' '\n' | grep -A1 -- -isysroot | tail -1)"
            export CMAKE_OSX_SYSROOT="$SDKROOT"
          '';
        };
      });
}
