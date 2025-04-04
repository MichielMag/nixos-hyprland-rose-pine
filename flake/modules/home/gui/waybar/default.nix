{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.waybar;
  wb-globalcontrol = pkgs.writeShellScriptBin "wb-globalcontrol" ''${builtins.readFile ./.scripts/globalcontrol.sh}'';
  wb-brightness = pkgs.writeShellScriptBin "wb-brightness" ''${builtins.readFile ./.scripts/brightness.sh}'';
  wb-cpuinfo = pkgs.writeShellScriptBin "wb-cpuinfo" ''${builtins.readFile ./.scripts/cpuinfo.sh}'';
  wb-ssid = pkgs.writeShellScriptBin "wb-ssid" ''${builtins.readFile ./.scripts/essid.sh}'';
  wb-volume = pkgs.writeShellScriptBin "wb-volume" ''${builtins.readFile ./.scripts/volume.sh}'';
  wb-logout = pkgs.writeShellScriptBin "wb-logout" ''${builtins.readFile ./.scripts/wlogout.sh}'';
  wb-toggle = pkgs.writeShellScriptBin "wb-toggle" ''${builtins.readFile ./.scripts/toggle-bar.sh}'';
in
{
  options.modules.waybar = {
    enable = mkEnableOption "waybar";
  };
  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      hypridle

      waybar
      wlogout
      brightnessctl
      playerctl
      lm_sensors
      jq

      wb-globalcontrol
      wb-brightness
      wb-cpuinfo
      wb-ssid
      wb-volume
      wb-logout
      wb-toggle
    ];

    home.activation = {
      waybarAction = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run rm -f $HOME/.config/waybar;
        run ln -s $HOME/.dotfiles/.config/waybar $HOME/.config/waybar;
      '';
    };
  };
}
