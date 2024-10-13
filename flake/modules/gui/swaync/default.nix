{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.swaync;

in
{
  options.modules.swaync = {
    enable = mkEnableOption "swaync";
  };
  config = mkIf cfg.enable {

    services.swaync = {
      enable = true;
    };
    home.activation = {
      swayncActivation = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        				run rm -f $HOME/.config/swaync;
                run ln -s $HOME/.dotfiles/.config/swaync $HOME/.config/swaync;
      '';
    };
  };
}
