{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.wlogout;
in
{
  options.modules.wlogout = {
    enable = mkEnableOption "wlogout";
  };
  config = mkIf cfg.enable {

    programs.wlogout.enable = true;

    home.activation = {
      wlogoutAction = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run rm -f $HOME/.config/wlogout;
        run ln -s $HOME/.dotfiles/.config/wlogout $HOME/.config/wlogout;
      '';
    };
  };
}
