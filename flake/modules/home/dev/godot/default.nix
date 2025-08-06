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
in
{
  options.modules.godot = {
    enable = mkEnableOption "godot";
  };
  config = mkIf cfg.enable {
    home.packages = [
      pkgs.godot_4_4-mono
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
