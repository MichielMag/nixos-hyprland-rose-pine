{
    description = "NixOS configuration";

    # All inputs for the system
    inputs = {
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

        #nur = {
        #    url = "github:nix-community/NUR";
        #    inputs.nixpkgs.follows = "nixpkgs";
        #};

        spicetify-nix.url = "github:the-argus/spicetify-nix";
        stylix.url = "github:danth/stylix";
        nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.4.1";
        #catppuccin.url = "github:catppuccin/nix";
        rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
        hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
    };

    # All outputs for the system (configs)
    outputs = { home-manager, nixpkgs, spicetify-nix, stylix, ... }@inputs: 
        let
            system = "x86_64-linux"; #current system
            pkgs = import nixpkgs { 
                inherit system;
                inherit nixpkgs; 
                config = {
                    allowUnfree = true;
                };
                overlays = [
                    inputs.hyprpanel.overlay.${system}
                ];
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
                        stylix.nixosModules.stylix
                        { networking.hostName = hostname; }
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
                                extraSpecialArgs = { 
                                    inherit inputs; 
                                    inherit spicetify-nix; 
                                };
                                # Home manager config (configures programs like firefox, zsh, eww, etc)
                                users.michiel = (./. + "/hosts/${hostname}/user.nix");
                            };
                            nixpkgs.config.allowUnfree = true;
                            nixpkgs.config.allowUnsupportedSystem = true;
                            #nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
                            #    "vscode"
                            #    "spotify"
                            #];
                            nixpkgs.overlays = [
                                inputs.hyprpanel.overlay
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
