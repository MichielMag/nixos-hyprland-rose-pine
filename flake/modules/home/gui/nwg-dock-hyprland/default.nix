{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.nwg-dock-hyprland;
in
{
  options.modules.nwg-dock-hyprland = {
    enable = mkEnableOption "nwg-dock-hyprland";
  };
  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      nwg-dock-hyprland
    ];

    home.activation = {
      hyprDockAction = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run rm -rf $HOME/.config/nwg-dock-hyprland;
        run ln -s $HOME/.dotfiles/.config/nwg-dock-hyprland $HOME/.config/nwg-dock-hyprland;
      '';
    };

  };
}
