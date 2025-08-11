{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.tidal;
in
{
  options.modules.tidal = {
    enable = mkEnableOption "tidal";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      cava
      mpv
      # tidal-hifi
      tidal-luna
    ];

  };
}
