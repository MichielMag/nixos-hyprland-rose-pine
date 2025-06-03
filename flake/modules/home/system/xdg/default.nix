{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.xdg;

in
{
  options.modules.xdg = {
    enable = mkEnableOption "xdg";
  };
  config = mkIf cfg.enable {
    xdg.userDirs = {
      enable = true;
      documents = "${config.home.homeDirectory}/documents/";
      download = "${config.home.homeDirectory}/downloads/";
      videos = "${config.home.homeDirectory}/videos/";
      music = "${config.home.homeDirectory}/music/";
      pictures = "${config.home.homeDirectory}/pictures/";
      desktop = "${config.home.homeDirectory}/desktop/";
      publicShare = "${config.home.homeDirectory}/public/";
      templates = "${config.home.homeDirectory}/templates/";
      extraConfig = {
        source = "${config.home.homeDirectory}/source/";
      };
      createDirectories = true;
    };
  };
}
