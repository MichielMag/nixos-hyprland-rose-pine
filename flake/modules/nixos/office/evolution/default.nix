{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.evolution;

in
{
  options.modules.evolution = {
    enable = mkEnableOption "evolution";
  };
  config = mkIf cfg.enable {

    programs.evolution.enable = true;
    programs.evolution.plugins = [ pkgs.evolution-ews ];
  };
}
