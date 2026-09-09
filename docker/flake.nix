{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    flake-utils.url = "github:numtide/flake-utils";
    liquido-nix.url = "github:mdcge/liquido-nix";
    # Reference base flake in GitHub (helps with Actions)
    root.url = "github:mdcge/LiquidOSimulations-nix";
    # Reference base flake in parent directory
    # root.url = "path:../";
  };

  outputs = { self, nixpkgs, flake-utils, liquido-nix, root, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        ratpac = liquido-nix.packages.${system}.liquido-ratpac;

        imagePackages = [
          ratpac
          pkgs.root          # HEP ROOT — needed at runtime and for CMake
          pkgs.cmake
          pkgs.pkg-config
          pkgs.gnumake
          pkgs.gcc
          pkgs.gitMinimal
          pkgs.bash
          pkgs.coreutils
          pkgs.findutils
          pkgs.gnugrep
          pkgs.gnused
          pkgs.which
        ];
      in {
        # local dev shell, unchanged
        devShells.default = pkgs.mkShell {
          inputsFrom = [ ratpac ];
          packages = [ ratpac pkgs.cmake pkgs.pkg-config ];
          shellHook = ''
            export CMAKE_PREFIX_PATH=${ratpac}:${pkgs.root}:$CMAKE_PREFIX_PATH
          '';
        };

        packages.dockerImage = pkgs.dockerTools.buildLayeredImage {
          name = "liquido-simulations";
          tag = "latest";

          contents = [
            # POSIX scaffolding: /etc/passwd, /etc/group, /tmp, basic shell
            pkgs.dockerTools.fakeNss
            pkgs.dockerTools.usrBinEnv

            # All packages in a merged FHS-like environment
            (pkgs.buildEnv {
              name = "liquido-simulations-env";
              paths = imagePackages;
              pathsToLink = [ "/bin" "/lib" "/lib64" "/include" "/share" "/etc" ];
              # Ignore conflicts between packages (e.g. duplicate /etc files)
              ignoreCollisions = true;
            })
          ];

          # Create /work and /tmp directories in the image
          extraCommands = ''
            mkdir -p work tmp
            chmod 1777 tmp
          '';

          config = {
            Env = [
              "CMAKE_PREFIX_PATH=${ratpac}:${pkgs.root}"
              "LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath imagePackages}"
              "PATH=/bin:/usr/bin"
            ];
            Cmd = [ "${pkgs.bash}/bin/bash" ];
            WorkingDir = "/work";
          };
        };
      });
}
