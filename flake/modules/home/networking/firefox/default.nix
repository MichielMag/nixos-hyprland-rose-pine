{
  pkgs,
  lib,
  config,
  firefox-addons,
  ...
}:

with lib;
let
  cfg = config.modules.firefox;
  customAddons = pkgs.callPackage ./addons.nix {
    inherit lib;
    inherit (firefox-addons.lib) buildFirefoxXpiAddon;
  };
  addons = with firefox-addons.packages; [
    bitwarden
    ublock-origin
    ghostery
    sponsorblock
    customAddons.rose-pine-moon-modified
  ];
in
{
  options.modules.firefox = {
    enable = mkEnableOption "firefox";
  };
  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      policies = {
        DisableTelemetry = true;
        DisableFirexoStudies = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          CryptoMining = true;
          FingerPrinting = true;
        };
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        DontCheckDefaultBrowser = true;
        DisplayBookmarksToolbar = "never";
        DisplayMenuBar = "default-off";
        SearchBar = "unified";
      };
      profiles = {
        default = {
          id = 0;
          extensions = addons;
          isDefault = true;
        };
        dev = {
          id = 1;
          extensions = addons ++ [
            firefox-addons.packages.angular-devtools
            firefox-addons.packages.reduxdevtools
          ];
        };
      };
    };
  };
}
