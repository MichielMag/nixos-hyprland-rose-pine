{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.packages;

in
{
  options.modules.packages = {
    enable = mkEnableOption "packages";
  };
  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      libnotify
      fastfetch
      dolphin
      dconf-editor
      wtype
    ];

    programs.firefox.enable = true;
    programs.btop = {
      enable = true;
      settings = {
        color_theme = "theme";
      };
    };
    xdg.enable = true;
    #xdg.mimeApps = {
    #  enable = true;
    #  defaultApplications = {
    #    "inode/directory" = [ "org.kde.dolphin.desktop" ];
    #  };
    #};

    services.swayosd.enable = true;
    services.cliphist = {
      enable = true;
      allowImages = true;
      extraOptions = [ "list | rofi -dmenu | cliphist decode | wl-copy" ];
    };

    home.activation = {
      btopActivation = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        				run rm -f $HOME/.config/btop/themes/theme.theme;
                run ln -s $HOME/.dotfiles/.config/btop/themes/theme.theme $HOME/.config/btop/themes/theme.theme;
      '';
    };
  };
}
