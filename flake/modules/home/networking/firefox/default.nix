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
  inherit (lib.attrsets) mapAttrs mapAttrs' nameValuePair;
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
    };
    Permissions = {
      Notifications = {
        Allow = [
          "https://web.whatsapp.com"
          "https://teams.live.com"
        ];
      };
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
    default = "ddg";
    order = [
      "ddg"
      "MyNixOS"
      "Nixpkgs"
    ];
    engines = {
      "google".metaData.hidden = true;
      "ecosia".metaData.hidden = true;
      "qwant".metaData.hidden = true;
      "bing".metaData.hidden = true;
      "ebay".metaData.hidden = true;
      "amazondotcom-us".metaData.hidden = true;
      "wikipedia".metaData.hidden = true;
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
    "browser.search.defaultenginename" = "ddg";
    "browser.search.order.1" = "ddg";
    "browser.aboutConfig.showWarning" = false;
    "browser.compactmode.show" = true;
  };
  make-pwa-profiles =
    cfg:
    mapAttrs' (
      name: config:
      nameValuePair "pwa-${name}" {
        id = config.profileId;
        isDefault = false;
        userChrome = ''
          @namespace url("http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul");

          browser {
            margin-right: 0px; margin-bottom: 0px;
          }

          #nav-bar, #identity-box, #tabbrowser-tabs, #TabsToolbar {
              visibility: collapse !important;
          }


          #nav-bar {
            margin-top: 0;
            margin-bottom: -42px;
            z-index: -100;
          }

          #main-window[windowtype="navigator:browser"] {
            background-color: transparent !important;
          }

          .tab-background[selected="true"] {
            background: #232136 !important;
          }
        '';
        settings = {
          "browser.sessionstore.resume_session_once" = false;
          "browser.sessionstore.resume_from_crash" = false;
          "browser.cache.disk.enable" = false;
          "browser.cache.disk.capacity" = 0;
          "browser.cache.disk.filesystem_reported" = 1;
          "browser.cache.disk.smart_size.enabled" = false;
          "browser.cache.disk.smart_size.first_run" = false;
          "browser.cache.disk.smart_size.use_old_max" = false;
          "browser.ctrlTab.previews" = true;
          "browser.tabs.warnOnClose" = false;
          "plugin.state.flash" = 2;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "browser.tabs.drawInTitlebar" = false;
          "browser.tabs.inTitlebar" = 0;
          "browser.contentblocking.category" = "strict";
          "network.cookie.lifetimePolicy" = 0;
        };
        extensions.packages = with firefox-addons.packages; [
          ublock-origin
          ghostery
          customAddons.rose-pine-moon-update
        ];
      }
    ) cfg;
in
{
  options.modules.firefox = {
    enable = mkEnableOption "firefox";
    pwa = mkOption {
      default = { };

      type =
        with lib.types;
        attrsOf (submodule {
          options = {
            url = mkOption {
              type = str;
              description = "The URL of the webapp to launch.";
            };
            profileId = mkOption {
              type = int;
              description = "The Firefox profile ID to set.";
            };
            #########################
            # Desktop file settings #
            #########################

            # Copied from xdg.desktopEntries, with slight modification for default settings
            name = mkOption {
              type = nullOr str;
              default = null;
              description = "Specific name of the application. Defaults to the capitalized attribute name.";
            };

            mimeType = mkOption {
              description = "The MIME type(s) supported by this application.";
              type = nullOr (listOf str);
              default = [
                "text/html"
                "text/xml"
                "application/xhtml_xml"
              ];
            };

            # Copied verbatim from xdg.desktopEntries.
            genericName = mkOption {
              type = nullOr str;
              default = null;
              description = "Generic name of the application.";
            };

            comment = mkOption {
              type = nullOr str;
              default = null;
              description = "Tooltip for the entry.";
            };

            categories = mkOption {
              type = nullOr (listOf str);
              default = null;
              description = "Categories in which the entry should be shown in a menu.";
            };

            icon = mkOption {
              type = nullOr (either str path);
              default = null;
              description = "Icon to display in file manager, menus, etc.";
            };

            prefersNonDefaultGPU = mkOption {
              type = nullOr bool;
              default = null;
              description = ''
                If true, the application prefers to be run on a more
                powerful discrete GPU if available.
              '';
            };
          };
        });
    };
  };
  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      inherit policies;
      profiles = {
        default = {
          id = 0;
          extensions.packages = addons;
          isDefault = true;
          inherit search;
          settings = settings // themed-settings;
          userChrome = builtins.readFile ./cascade/userChrome.css;
          userContent = builtins.readFile ./assets/userContent.css;
        };
        dev = {
          id = 1;
          extensions.packages = addons ++ [
            firefox-addons.packages.angular-devtools
            firefox-addons.packages.reduxdevtools
          ];
          inherit search;
          inherit settings;
        };
      } // make-pwa-profiles cfg.pwa;
    };
    xdg.desktopEntries = mapAttrs (name: cfg: {
      inherit (cfg)
        genericName
        comment
        categories
        icon
        mimeType
        prefersNonDefaultGPU
        ;

      name =
        if cfg.name == null then
          (toUpper (substring 0 1 name)) + (substring 1 (stringLength name) name)
        else
          cfg.name;

      startupNotify = true;
      terminal = false;
      type = "Application";

      exec = concatStringsSep " " (
        [
          "${config.programs.firefox.package}/bin/firefox"
          "--class"
          "\"${name} pwa\""
          "--name"
          "\"${name} pwa\""
          "-P"
          "${config.programs.firefox.profiles."pwa-${name}".path}"
          "--no-remote"
        ]
        ++ [ "${cfg.url}" ]
      );

      settings = {
        X-MultipleArgs = "false"; # Consider enabling, don't know what this does
        StartupWMClass = "${name} pwa";
      };
    }) cfg.pwa;
  };
}
