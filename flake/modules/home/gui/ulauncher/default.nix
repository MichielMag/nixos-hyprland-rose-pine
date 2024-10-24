{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.ulauncher;

in
{
  options.modules.ulauncher = {
    enable = mkEnableOption "ulauncher";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ulauncher
    ];
    home.activation = {
      ulauncherAction = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run rm -f $HOME/.config/ulauncher;
        run ln -s $HOME/.dotfiles/.config/ulauncher $HOME/.config/ulauncher;
      '';
    };
  };
}
