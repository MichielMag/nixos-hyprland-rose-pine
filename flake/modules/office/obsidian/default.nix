{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.obsidian;

in
{
  options.modules.obsidian = {
    enable = mkEnableOption "obsidian";
  };
  config = mkIf cfg.enable {

    home.packages = [
      pkgs.obsidian
    ];

    xdg.desktopEntries."obsidian" = {
      name = "Obsidian";
      terminal = false;
      type = "Application";
      comment = "Knowledge base";
      genericName = "Notes";
      exec = "obsidian --use-gl=egl --enable-features=ozone --ozone-platform=wayland %u";
      icon = "obsidian";
      categories = [ "Office" ];
      mimeType = [ "x-scheme-handler/obsidian" ];
    };
  };
}
