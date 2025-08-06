{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.godot;
  godotFix = pkgs.godot.override {
    withMono = true;
    withWayland = true;
  };
in
{
  options.modules.godot = {
    enable = mkEnableOption "godot";
  };
  config = mkIf cfg.enable {
    home.packages = [
      godotFix
    ];

    xdg.desktopEntries = {
      "org.godotengine.Godot4-mono" = {
        name = "Godot Engine 4";
        type = "Application";
        genericName = "Libre game engine";
        icon = "godot";
        exec = "godot4-mono --display-driver wayland %f";
        terminal = false;
        mimeType = [ "Libre game engine" ];
        categories = [
          "Development"
          "IDE"
        ];
        settings = {
          StartupWMClass = "Godot";
          PrefersNonDefaultGPU = "true";
        };
      };
    };

  };
}
