{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
    ratpac-nix.url = "github:mdcge/ratpac-nix";
  };

  outputs = { self, nixpkgs, flake-utils, ratpac-nix, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (final: prev: {
              ratpac-two = ratpac-nix.packages.${system}.ratpac-two.overrideAttrs (old: {
                patches = (old.patches or []) ++ [
                  ./nix/patches/liquido-ratpac.patch
                ];
              });
            })
          ];
        };
        ratpac = pkgs.ratpac-two;
      in {
        devShells.default = pkgs.mkShell {
          inputsFrom = [ ratpac ];
          packages = [ ratpac pkgs.cmake pkgs.pkg-config ];
          shellHook = ''
            export CMAKE_PREFIX_PATH=${ratpac}:${pkgs.root}:$CMAKE_PREFIX_PATH
          '';
        };
      });
}
