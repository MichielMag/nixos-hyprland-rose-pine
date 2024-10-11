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
    ];

    programs.firefox.enable = true;
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
  };
}
