# LiquidOSimulations Nix environment
This repository contains the necessary files to create a Nix environment with LiquidO's fork of ratpac-two. This environment can be used to build LiquidOSimulations.

## Installing Nix
Note: Determinate Nix is not supported for `x86_64-darwin` (Intel Mac). You will have to go through the official installer for that architecture.

In order to use this repo, you must install [Nix](https://nixos.org/). This is possible via the official Nix channels, but a slightly more streamlined and ergonomic approach is to use [Determinate Nix](https://docs.determinate.systems/determinate-nix/).

In short, to install Nix, run the command

``` zsh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

and to uninstall run

``` zsh
/nix/nix-installer uninstall
```

## Enabling the environment
To enter the environment with the necessary programs available, simply run

``` zsh
nix develop
```

In this instance, you can check this has worked by running `rat`.

### Automating with `direnv`
This process can be automated (among other advantages) using `direnv`. To use this,

1. Install `direnv`:

``` zsh
nix profile install nixpkgs#direnv
```
2. Hook it into the shell:

``` zsh
eval "$(direnv hook bash)"  # in ~/.bashrc
eval "$(direnv hook zsh)"   # in ~/.zshrc
eval `direnv hook tcsh`     # in ~/.cshrc
```

The first time you enter a shell with a `.envrc` file and `direnv` enabled, the command `direnv allow` will be needed to initiate the environment activation.

## Building LiquidOSimulations
Once the environment is set up with ratpac available, first clone LiquidOSimulations in this directory (`LiquidOSimulations` should sit next to `flake.nix`):

``` zsh
git clone https://gitlab.in2p3.fr/liquid-o/liquido-general/LiquidOSimulations.git
```

Then, in the `LiquidOSimulations` directory, build:

``` zsh
mkdir build && cd build
cmake ..
make
cd ..
source liquido.sh
```
