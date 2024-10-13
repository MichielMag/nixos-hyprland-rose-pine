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

    home.packages = with pkgs; [
      obsidian
    ];

    # home.activation = {
    #   swayncActivation = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    #     run rm -f $HOME/.config/swaync;
    #     run ln -s $HOME/.dotfiles/.config/swaync $HOME/.config/swaync;
    #   '';
    # };
  };
}
