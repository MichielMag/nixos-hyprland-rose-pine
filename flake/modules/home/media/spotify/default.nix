{
  pkgs,
  lib,
  config,
  spicetify-nix,
  ...
}:

with lib;
let
  cfg = config.modules.spotify;
  spicePkgs = spicetify-nix.legacyPackages.${pkgs.system};
in
{
  options.modules.spotify = {
    enable = mkEnableOption "spotify";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      cava
      mpv
    ];

    programs.spicetify = {
      enable = true;
      theme = spicePkgs.themes.text;
      colorScheme = "Nord";
    };

    xdg.desktopEntries = {
      spotify = {
        name = "Spotify";
        type = "Application";
        genericName = "Music Player";
        icon = "spotify-client";
        exec = "spotify --use-gl=egl --enable-features=UseOzonePlatform --ozone-platform=wayland %U";
        terminal = false;
        mimeType = [ "x-scheme-handler/spotify" ];
        categories = [
          "Audio"
          "Music"
          "Player"
          "AudioVideo"
        ];
        settings = {
          StartupWMClass = "spotify";
        };
      };
    };
  };
}
