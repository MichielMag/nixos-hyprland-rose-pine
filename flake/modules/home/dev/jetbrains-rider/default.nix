{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.jetbrains-rider;
in
{
  options.modules.jetbrains-rider = {
    enable = mkEnableOption "jetbrains-rider";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      jetbrains.rider
    ];
  };
}
