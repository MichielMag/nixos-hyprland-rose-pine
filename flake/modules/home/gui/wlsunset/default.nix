{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.wlsunset;
in
{
  options.modules.wlsunset = {
    enable = mkEnableOption "wlsunset";
  };
  config = mkIf cfg.enable {

    programs.wlsunset = {
      enable = true;
      latitude = 52.090736;
      longitude = 5.12142;
      temperature = {
        day = 6000;
        night = 5000;
      };
      gamma = 0.95;
    };

  };
}
