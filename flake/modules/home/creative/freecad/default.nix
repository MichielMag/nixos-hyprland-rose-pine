{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.freecad;

in
{
  options.modules.freecad = {
    enable = mkEnableOption "freecad";
  };
  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      freecad-wayland
    ];

  };
}
