{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.bruno;
in
{
  options.modules.bruno = {
    enable = mkEnableOption "bruno";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      bruno
    ];

    xdg.desktopEntries."bruno" = {
      name = "bruno";
      desktopName = "Bruno";
      exec = "bruno --use-gl=egl %U";
      icon = "bruno";
      comment = "Opensource API Client for Exploring and Testing APIs";
      categories = [ "Development" ];
      startupWMClass = "Bruno";
    };
  };
}
