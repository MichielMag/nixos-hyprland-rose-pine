{
  pkgs,
  lib,
  config,
  spicetify-nix,
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
      high-tide
    ];
  };
}
