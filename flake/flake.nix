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

    nurpkgs.url = "github:nix-community/NUR";

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

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };
    # ags.url = "github:aylur/ags";
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
      firefox-addons,
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
        pkgs: system: hostname: gui:
        pkgs.lib.nixosSystem {
          system = system;
          modules = [
            { networking.hostName = hostname; }
            home-manager.nixosModules.home-manager
            stylix.nixosModules.stylix
            ./modules/nixos/system
            ./modules/nixos/stylix
            (./. + "/hosts/${hostname}/hardware-configuration.nix")
            (./. + "/hosts/${hostname}/settings.nix")
            {
              home-manager = {
                backupFileExtension = "bak";
                useUserPackages = true;
                useGlobalPkgs = true;
                extraSpecialArgs = {
                  inherit inputs;
                  inherit spicetify-nix;
                  firefox-addons = {
                    lib = firefox-addons.lib.${system};
                    packages = firefox-addons.packages.${system};
                  };
                  meta = {
                    inherit system;
                    inherit hostname;
                  };
                };
                users.michiel = (./. + "/hosts/${hostname}/user.nix");
              };
              nixpkgs.config.allowUnfree = true;

              # Temp solution for godot 4.3
              nixpkgs.config.permittedInsecurePackages = [
                "dotnet-sdk-6.0.428"
              ];

              nixpkgs.overlays = [
                (final: prev: {
                  split-monitor-workspaces = split-monitor-workspaces.packages.${system}.split-monitor-workspaces;
                  stable = import inputs.nixpkgs-stable {
                    system = final.system;
                    config.allowUnfree = true;
                  };
                  vscode-marketplace = inputs.nix-vscode-extensions.extensions.${system}.vscode-marketplace;
                  vscode = final.callPackage ./packages/vscode/vscode.nix { };
                })
                inputs.nurpkgs.overlay
              ];
            }

          ];
          specialArgs = {
            inherit inputs;
          };
        };

    in
    {
      nixosConfigurations = {
        quickemu = mkSystem inputs.nixpkgs "x86_64-linux" "quickemu" true;
        thinkpad = mkSystem inputs.nixpkgs "x86_64-linux" "thinkpad" true;
        xps13 = mkSystem inputs.nixpkgs "x86_64-linux" "xps13" true;
      };
    };
}
