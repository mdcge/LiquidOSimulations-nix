# LiquidOSimulations Nix environment

## Installing Nix
Note: Determinate Nix is not supported for `x86_64-darwin` (Intel Mac).

To install Nix, follow the [installation instructions](https://determinate.systems/blog/determinate-nix-installer/).

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
