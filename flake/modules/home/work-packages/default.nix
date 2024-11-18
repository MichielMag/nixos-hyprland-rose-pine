{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.work-packages;

in
{
  options.modules.work-packages = {
    enable = mkEnableOption "work-packages";
  };
  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      slack
      teams-for-linux
      (citrix_workspace.override {
        libvorbis = pkgs.libvorbis.override {
          libogg = pkgs.libogg.overrideAttrs (prevAttrs: {
            cmakeFlags = (prevAttrs.cmakeFlags or [ ]) ++ [
              (lib.cmakeBool "BUILD_SHARED_LIBS" true)
            ];
          });
        };
      })
    ];

    xdg.desktopEntries = {
      teams-for-linux = {
        exec = "teams-for-linux --use-gl=egl --enable-features=WebRTCPipeWireCapturer %U";
        icon = "teams-for-linux";
        name = "Microsoft Teams for Linux";
        comment = "Unofficial Microsoft Teams client for Linux using Electron";
        categories = [
          "Network"
          "InstantMessaging"
          "Chat"
        ];
      };
      slack = {
        name = "Slack";
        comment = "Slack Desktop";
        genericName = "Slack Client for Linux";
        exec = "slack --use-gl=egl %U";
        icon = "slack";
        type = "Application";
        startupNotify = true;
        categories = [
          "GNOME"
          "GTK"
          "Network"
          "InstantMessaging"
        ];
        mimeType = [ "x-scheme-handler/slack" ];
        settings = {
          StartupWMClass = "Slack";
        };
      };
    };
  };
}
