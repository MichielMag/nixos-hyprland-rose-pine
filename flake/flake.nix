{
  description = "NixOS configuration";

  # All inputs for the system
  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    #nur = {
    #    url = "github:nix-community/NUR";
    #    inputs.nixpkgs.follows = "nixpkgs";
    #};

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    stylix.url = "github:danth/stylix";
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland"; # <- make sure this line is present for the plugin to work as intended
    };
    #catppuccin.url = "github:catppuccin/nix";
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
  };

  # All outputs for the system (configs)
  outputs =
    {
      home-manager,
      nixpkgs,
      nixpkgs-stable,
      spicetify-nix,
      stylix,
      split-monitor-workspaces,
      ...
    }@inputs:
    let
      system = "x86_64-linux"; # current system
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
      mkSystem =
        pkgs: system: hostname:
        pkgs.lib.nixosSystem {
          system = system;
          modules = [
            stylix.nixosModules.stylix
            { networking.hostName = hostname; }
            ./modules/nixos/system
            ./modules/nixos/stylix
            # Hardware config (bootloader, kernel modules, filesystems, etc)
            # DO NOT USE MY HARDWARE CONFIG!! USE YOUR OWN!!
            (./. + "/hosts/${hostname}/hardware-configuration.nix")
            (./. + "/hosts/${hostname}/settings.nix")
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
              #nixpkgs.config.allowUnsupportedSystem = true;
              #nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
              #    "vscode"
              #    "spotify"
              #];
              nixpkgs.overlays = [
                (final: prev: {
                  split-monitor-workspaces = split-monitor-workspaces.packages.${system}.split-monitor-workspaces;
                  stable = import inputs.nixpkgs-stable {
                    system = final.system;
                    config.allowUnfree = true;
                  };
                })

              ];
            }

            #stylix.nixosModules.stylix
          ];
          specialArgs = {
            inherit inputs;
          };
        };

    in
    {
      nixosConfigurations = {
        # Now, defining a new system is can be done in one line
        #                                Architecture   Hostname
        quickemu = mkSystem inputs.nixpkgs "x86_64-linux" "quickemu";
        thinkpad = mkSystem inputs.nixpkgs "x86_64-linux" "thinkpad";
	xps13 = mkSystem inputs.nixpkgs "x86_64-linux" "xps13";
      };
    };
}
