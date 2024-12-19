{
  description = "NixOS configuration";

  inputs = {
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

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

  outputs =
    { ... }@inputs:
    let
      util = import ./lib/default.nix { inherit inputs; };
      nixosDefaultModules = [
        inputs.home-manager.nixosModules.home-manager
        inputs.stylix.nixosModules.stylix
        ./flake/modules/nixos
      ];
      homeManagerDefaultModules = [
        ./flake/modules/home
      ];
    in
    {
      nixosModules.default = nixosDefaultModules;
      homeManagerModules.default = homeManagerDefaultModules;
    };
}
