# LiquidOSimulations Nix environment
This repository contains the necessary files to create a Nix environment with LiquidO's fork of ratpac-two. This environment can be used to build LiquidOSimulations.

## Installing Nix
Note: Determinate Nix is not supported for `x86_64-darwin` (Intel Mac). You will have to go through the official installer for that architecture.

In order to use this repo, you must install [Nix](https://nixos.org/). This is possible via the official Nix channels, but a slightly more streamlined and ergonomic approach is to use [Determinate Nix](https://docs.determinate.systems/determinate-nix/) (link to detailed [GitHub page](https://github.com/DeterminateSystems/nix-installer)).

In short, to install Nix, run the command

``` zsh
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
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

This environment is active for the duration of the shell session, so you can freely navigate your file system while still having access to these commands. You will need to re-`develop` when opening a new shell.

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
make
cd ..
source liquido.sh
```

## Creating container images
One of the many benefits of Nix is the ability to easily create container images, using the pre-existing Nix configuration files. Natively, Nix supports Docker images which can be created as follows (with Docker installed):

``` zsh
nix build ./docker#dockerImage && docker load < result
```

Then push to the GitHub registry:

``` zsh
docker tag <image-name> ghcr.io/<repo-name>/<image-name>
docker push ghcr.io/<repo-name>/<image-name>
```

## Using container images
In order to use a docker image in the GitHub registry, either find it in the "Packages" section of the target repository, or run:

``` zsh
docker pull ghcr.io/<repo-name>/<image-name>
```
