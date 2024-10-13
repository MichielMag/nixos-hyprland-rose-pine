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
  config = {
    home.activation = {
      dunstAction = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run rm -f $HOME/.config/shared;
        run ln -s $HOME/.dotfiles/.config/shared $HOME/.config/shared;
      '';
    };
  };
}
