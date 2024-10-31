{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.rofi;

  bwmenu-rofi = pkgs.callPackage ../../../../packages/bwmenu.nix { };
in
{
  options.modules.rofi = {
    enable = mkEnableOption "rofi";
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      rofi-wayland
      bwmenu-rofi
    ];

    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
    };

    home.activation = {
      rofiAction = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run rm -rf $HOME/.config/rofi;
        run ln -s $HOME/.dotfiles/.config/rofi $HOME/.config/rofi;
      '';
    };

    #home.file.".config/rofi/adi1090x" = {
    #    source = "${adi1090x-rofi}/files";
    #    recursive = true;
    #    target = ".config/rofi/adi1090x";
    #};

    #home.file.".local/share/fonts" = {
    #    source = "${adi1090x-rofi}/fonts";
    #    recursive = true;
    #};
  };
}
