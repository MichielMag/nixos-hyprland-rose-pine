# NHRP

Welcome to my personal NixOS configuration / Hyprland dotfiles repository.

# Installation

1. Clone the repository to your NixOS machine
2. Make a new folder in 'flake/hosts'.
3. Copy your `hardware-configuration.nix` to that host folder, I.E.

    cp /etc/nix/hardware-configuration.nix ~/source/nixos-hyprland-rose-pine/flake/hosts/personal-laptop

4. Create a `settings.nix` file to include some host-specific settings that don't belong to your `hardware-configuration.nix`, or make it an empty file (see the existing hosts for examples).
5. Create a `user.nix` file to enable modules. See existing hosts for examples.
6. Add your hosts to the bottom of `flake.nix` (see file for existing examples)
7. Install by using the following command:

    bash install.sh `your-host-name`

# Credits

I'm afraid I'm missing a couple of scripts that I borrowed of the internet, but here's a small list:

-   https://github.com/kellya/rofi-sound
