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
  wb-brightness = pkgs.writeShellScriptBin "wb-brightness" ''${builtins.readFile ./.scripts/brightness.sh}'';
  wb-cpuinfo = pkgs.writeShellScriptBin "wb-cpuinfo" ''${builtins.readFile ./.scripts/cpuinfo.sh}'';
in
{
  options.modules.waybar = {
    enable = mkEnableOption "waybar";
  };
  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      dunst
      hypridle

      waybar
      wlogout
      brightnessctl
      playerctl

      wb-brightness
      wb-cpuinfo
    ];

    home.activation = {
      waybarAction = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run rm -f $HOME/.config/waybar;
        run ln -s $HOME/.dotfiles/.config/waybar $HOME/.config/waybar;
      '';
    };
  };
}
