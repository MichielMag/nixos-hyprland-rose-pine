{
  pkgs,
  lib,
  config,
  spicetify-nix,
  ...
}:

with lib;
let
  cfg = config.modules.media;
  spicePkgs = spicetify-nix.legacyPackages.${pkgs.system};
in
{
  options.modules.media = {
    enable = mkEnableOption "media";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      #spotify
    ];

    programs.spicetify = {
      enable = true;
      theme = spicePkgs.themes.ziro;
      colorScheme = "rose-pine-moon";
    };

    # xdg.desktopEntries = {
    #   spotify = {
    #     name = "Spotify";
    #     type = "Application";
    #     genericName = "Music Player";
    #     icon = "spotify-client";
    #     exec = "spotify --enable-feature=UseOzonePlatform --ozone-platform=wayland %U";
    #     terminal = false;
    #     mimeType = [ "x-scheme-handler/spotify" ];
    #     categories = [
    #       "Audio"
    #       "Music"
    #       "Player"
    #       "AudioVideo"
    #     ];
    #     settings = {
    #       StartupWMClass = "spotify";
    #     };
    #   };
    # };

  };
}
