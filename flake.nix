{
    description = "NixOS configuration";

    # All inputs for the system
    inputs = {
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

        nur = {
            url = "github:nix-community/NUR";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        #catppuccin.url = "github:catppuccin/nix";

        rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    };

    # All outputs for the system (configs)
    outputs = { home-manager, nixpkgs, nur, ... }@inputs: 
        let
            system = "x86_64-linux"; #current system
            pkgs = import nixpkgs { 
                inherit nixpkgs; 
                system = "x86_64-linux";
                config = {
                    allowUnfree = true;
                };
            };
            #pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            lib = nixpkgs.lib;

            # This lets us reuse the code to "create" a system
            # Credits go to sioodmy on this one!
            # https://github.com/sioodmy/dotfiles/blob/main/flake.nix
            mkSystem = pkgs: system: hostname:
                pkgs.lib.nixosSystem {
                    system = system;
                    modules = [
                        #catppuccin.nixosModules.catppuccin
                        { networking.hostName = hostname; }
                        # General configuration (users, networking, sound, etc)
                        ./modules/system/configuration.nix
                        ./modules/styling/styling.nix
                        # Hardware config (bootloader, kernel modules, filesystems, etc)
                        # DO NOT USE MY HARDWARE CONFIG!! USE YOUR OWN!!
                        (./. + "/hosts/${hostname}/hardware-configuration.nix")
                        home-manager.nixosModules.home-manager
                        {
                            home-manager = {
                                backupFileExtension = "bak";
                                useUserPackages = true;
                                useGlobalPkgs = true;
                                extraSpecialArgs = { inherit inputs; };
                                # Home manager config (configures programs like firefox, zsh, eww, etc)
                                users.michiel = (./. + "/hosts/${hostname}/user.nix");
                            };
                            nixpkgs.overlays = [
                                # Add nur overlay for Firefox addons
                                nur.overlay
                                (import ./overlays)
                            ];
                        }
                        #stylix.nixosModules.stylix
                    ];
                    specialArgs = { inherit inputs; };
                };

        in {
            nixosConfigurations = {
                # Now, defining a new system is can be done in one line
                #                                Architecture   Hostname
                quickemu = mkSystem inputs.nixpkgs "x86_64-linux" "quickemu";
                thinkpad = mkSystem inputs.nixpkgs "x86_64-linux" "thinkpad";
            };
    };
}
