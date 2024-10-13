{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.dunst;
in
{
  options.modules.dunst = {
    enable = mkEnableOption "dunst";
  };
  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      dunst
    ];

    home.activation = {
      waybarAction = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run rm -f $HOME/.config/dunst;
        run ln -s $HOME/.dotfiles/.config/dunst $HOME/.config/dunst;
      '';
    };
  };
}
