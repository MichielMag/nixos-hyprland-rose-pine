{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.rofi;
in
#adi1090x-rofi = pkgs.fetchFromGitHub {
#    owner = "MichielMag";
#    repo = "adi1090x-rofi";
#    rev = "e13471745d2b825baf5a82173f9d126512379a8c";
#    sha256 = "08g2bvciy2mg5fkvhz3x06im5ayrcaihixghnzxkg8jhwk5dzpxb";
#};
{
  options.modules.rofi = {
    enable = mkEnableOption "rofi";
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      rofi-wayland
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
