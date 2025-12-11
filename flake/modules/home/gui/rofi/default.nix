{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.rofi;

  audio-selector-rofi = pkgs.writeShellScriptBin "audio-selector-rofi" ''${builtins.readFile ./.scripts/audio-selector-rofi.sh}'';
in
{
  options.modules.rofi = {
    enable = mkEnableOption "rofi";
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      rofi
      audio-selector-rofi
    ];

    programs.rofi = {
      enable = true;
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
