{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.insomnia;
in
{
  options.modules.insomnia = {
    enable = mkEnableOption "insomnia";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      insomnia
    ];

    xdg.desktopEntries."insomnia" = {
      name = "insomnia";
      exec = "insomnia --use-gl=egl --enable-features=UseOzonePlatform --ozone-platform=wayland %U";
      icon = "insomnia";
      comment = "Opensource API Client for Exploring and Testing APIs";
      categories = [ "Development" ];

      type = "Application";
      genericName = "Rest API Client";
      mimeType = [ "x-scheme-handler/obsidian" ];
      settings = {
        StartupWMClass = "insomnia";
      };
    };
  };
}
