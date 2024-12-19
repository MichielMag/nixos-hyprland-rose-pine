{ inputs }:
let
  util = (import ./default.nix) { inherit inputs; };
  outputs = inputs.self.outputs;
  pkgs = inputs.nixpkgs;
in
rec {
  pkgsFor = sys: inputs.nixpkgs.legacyPackages.${sys};
  mkSystem =
    system: hostname:
    pkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs outputs util;
      };

      modules = [
        outputs.nixosModules.default
        (./hosts/${hostname}/hardware-configuration.nix)
        (./hosts/${hostname}/settings.nix)
      ];
    };
  mkHome =
    system: hostname:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = pkgsFor system;
      modules = [
        outputs.homeManagerModules.default
        (./hosts/${hostname}/user.nix)
      ];
    };
}
