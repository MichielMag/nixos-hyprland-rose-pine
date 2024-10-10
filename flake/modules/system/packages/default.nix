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
      nemo-with-extensions
      dconf-editor
      brave
    ];

    # xdg.desktopEntries = {
    #   brave-browser = {
    #     name = "Brave Web Browser";
    #     exec = "${pkgs.brave}/bin/brave --enable-feature=UseOzonePlatform --ozone-platform=wayland %U";
    #     startupNotify = true;
    #     terminal = false;
    #     icon = "brave-browser";
    #     type = "Application";
    #     categories = [
    #       "Network"
    #       "WebBrowser"
    #     ];
    #     mimeType = [
    #       "application/pdf"
    #       "application/rdf+xml"
    #       "application/rss+xml"
    #       "application/xhtml+xml"
    #       "application/xhtml_xml"
    #       "application/xml"
    #       "image/gif"
    #       "image/jpeg"
    #       "image/png"
    #       "image/webp"
    #       "text/html"
    #       "text/xml"
    #       "x-scheme-handler/http"
    #       "x-scheme-handler/https"
    #     ];
    # 
    #     actions = {
    #       new-window.exec = "${pkgs.brave}/bin/brave --enable-feature=UseOzonePlatform --ozone-platform=wayland";
    #       new-private-window.exec = "${pkgs.brave}/bin/brave --enable-feature=UseOzonePlatform --ozone-platform=wayland --incognito";
    #     };
    #   };
    # };

    services.swayosd.enable = true;
    services.cliphist = {
      enable = true;
      allowImages = true;
      extraOptions = [ "list | rofi -dmenu | cliphist decode | wl-copy" ];
    };
  };
}
