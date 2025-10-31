{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.ldtk;
in
{
  options.modules.ldtk = {
    enable = mkEnableOption "ldtk";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ldtk
    ];
  };
}
