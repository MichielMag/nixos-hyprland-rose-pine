{
  pkgs,
  lib,
  config,
  firefox-addons,
  inputs,
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
  policies = {
    DisableTelemetry = true;
    DisableFirexoStudies = true;
    EnableTrackingProtection = {
      Value = true;
      Locked = true;
      CryptoMining = true;
      FingerPrinting = true;
    };
    UserMessaging = {
      UrlbarInterventions = false;
      SkipOnboarding = true;
    };
    FirefoxSuggest = {
      WebSuggestions = false;
      SponsoredSuggestions = false;
      ImproveSuggest = false;
    };
    OverrideFirstRunPage = "";
    OverridePostUpdatePage = "";
    DontCheckDefaultBrowser = true;
    DisplayBookmarksToolbar = "never";
    DisplayMenuBar = "default-off";
    SearchBar = "unified";
    FirefoxHome = # Make new tab only show search
      {
        Search = true;
        TopSites = false;
        SponsoredTopSites = false;
        Highlights = false;
        Pocket = false;
        SponsoredPocket = false;
        Snippets = false;
      };
    Preferences = {
      "browser.in-content.dark-mode" = true; # Use dark mode
      "ui.systemUsesDarkTheme" = true;

      "extensions.autoDisableScopes" = 0; # Automatically enable extensions
      "extensions.update.enabled" = false;
      "extensions.activeThemeID" = customAddons.rose-pine-moon-modified.addonId;
    };
  };
  themed-settings = {
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # Enable userChrome.css
    "svg.context-properties.content.enabled" = true;
    "layout.css.has-selector.enabled" = true;
    "browser.urlbar.suggest.calculator" = true;
    "browser.urlbar.unitConversion.enabled" = true;
    "browser.urlbar.trimHttps" = true;
    "browser.tabs.inTitlebar" = 0;
    "browser.urlbar.trimURLs" = true;
    "widget.gtk.rounded-bottom-corners.enabled" = true;
    "widget.gtk.ignore-bogus-leave-notify" = true;
  };
  search = {
    force = true;
    default = "DuckDuckGo";
    order = [
      "DuckDuckGo"
      "MyNixOS"
      "Nixpkgs"
    ];
    engines = {
      "Google".metaData.hidden = true;
      "Bing".metaData.hidden = true;
      "eBay".metaData.hidden = true;
      "Amazon.com".metaData.hidden = true;
      "Wikipedia (en)".metaData.hidden = true;
      "MyNixOS" = {
        urls = lib.singleton {
          template = "https://mynixos.com/search";
          params = lib.attrsToList {
            "q" = "{searchTerms}";
          };
        };
        definedAliases = [ "@mn" ];
      };
      "Nixpkgs" = {
        urls = lib.singleton {
          template = "https://github.com/search";
          params =
            lib.attrsToList # Thanks to xunuwu on github for being a reference to use of these functions
              {
                "type" = "code";
                "q" = "repo:NixOS/nixpkgs lang:nix {searchTerms}";
              };
        };
        definedAliases = [ "@npkgs" ];
      };
    };
  };
  settings = {
    "signon.rememberSignons" = false;
    "services.sync.engine.passwords" = false;
    "browser.search.defaultenginename" = "DuckDuckGo";
    "browser.search.order.1" = "DuckDuckGo";
    "browser.aboutConfig.showWarning" = false;
    "browser.compactmode.show" = true;

    "extensions.activeThemeID" = customAddons.rose-pine-moon-modified.addonId;
  };
in
{
  options.modules.firefox = {
    enable = mkEnableOption "firefox";
  };
  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      inherit policies;
      profiles = {
        default = {
          id = 0;
          extensions = addons ++ [
            customAddons.userchrome-toggle-extended
          ];
          isDefault = true;
          inherit search;
          settings = settings // themed-settings;
          userChrome = builtins.readFile ./assets/userChrome.css;
        };
        dev = {
          id = 1;
          extensions = addons ++ [
            firefox-addons.packages.angular-devtools
            firefox-addons.packages.reduxdevtools
          ];
          inherit search;
          inherit settings;
        };
      };
    };
  };
}
