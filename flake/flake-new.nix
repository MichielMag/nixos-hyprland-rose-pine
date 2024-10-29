{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland";
    stylix.url = "github:danth/stylix";
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";

    split-monitor-workspaces.url = "github:Duckonaut/split-monitor-workspaces";
    split-monitor-workspaces.inputs.hyprland.follows = "hyprland"; # <- make sure this line is present for the plugin to work as intended
    
    rycee-nurpkgs.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    rycee-nurpkgs.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs:
  let 
    makeHM = inputs: hostname: system:
      {
        home-manager = {
          backupFileExtension = "bak";
          useUserPackages = true;
          useGlobalPkgs = true;
          extraSpecialArgs = {
            inherit inputs;
            spicetify-nix =  inputs.spicetify-nix;
            firefox-addons =  
          };
        }
      }
    makeSystem = inputs: system: hostname: 
    inputs.nixpkgs.lib.nixosSystem {
      system = system;
      modules = [
        inputs.stylix.nixosModules.stylix
        inputs.home-manager.nixosModules.home-manager
        ./modules/nixos/system
        ./modules/nixos/stylix
        (./. + "/hosts/${hostname}/hardware-configuration.nix")
        (./. + "/hosts/${hostname}/settings.nix")
      ];
      pkgs = import inputs.nixpkgs {
        inherit system;
        inherit inputs.nixpkgs;
        config = {
          allowUnfree = true;
        };
        overlays = [
          inputs.hyprpanel.overlay.${system}
        ];
      };
      lib = inputs.nixpkgs.lib;
    };
  in
  {
    nixosConfigurations = {
      thinkpad = makeSystem inputs "x86_64-linux" "thinkpad";
      xps13 = makeSystem inputs "x86_64-linux" "xps13";
    };
  };
}
