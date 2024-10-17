{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.nix-ld;
in
{
  options.modules.nix-ld = {
    enable = mkEnableOption "nix-ld";
  };
  config = mkIf cfg.enable {
    programs.nix-ld = {
      enable = true;
    };
  };
}
