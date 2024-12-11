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
  cfg = config.modules.shyfox;
  customAddons = pkgs.callPackage ./addons.nix {
    inherit lib;
    inherit (firefox-addons.lib) buildFirefoxXpiAddon;
  };
  shyfox-settings = {
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # Enable userChrome.css
    "sidebar.revamp" = false;
    "svg.context-properties.content.enabled" = true;
    "layout.css.has-selector.enabled" = true;
    "browser.urlbar.suggest.calculator" = true;
    "browser.urlbar.unitConversion.enabled" = true;
    "browser.urlbar.trimHttps" = true;
    "browser.urlbar.trimURLs" = true;
    "widget.gtk.rounded-bottom-corners.enabled" = true;
    "widget.gtk.ignore-bogus-leave-notify" = true;
  };
  addons = with firefox-addons.packages; [
    bitwarden
    ublock-origin
    ghostery
    sponsorblock
    sidebery
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
    };
    "3rdparty" = {
      Extensions = {
        "userchrome-toggle-extended@n2ezr.ru" = {
          allowMultiple = true;
          closePopup = true;
        };
        "{3c078156-979c-498b-8990-85f7987dd929}" = {
          "settings" = {
            "nativeScrollbars" = false;
            "nativeScrollbarsThin" = false;
            "nativeScrollbarsLeft" = false;
            "selWinScreenshots" = false;
            "updateSidebarTitle" = false;
            "markWindow" = false;
            "markWindowPreface" = "sdbr ";
            "ctxMenuNative" = false;
            "ctxMenuRenderInact" = false;
            "ctxMenuRenderIcons" = true;
            "ctxMenuIgnoreContainers" = "";
            "navBarLayout" = "horizontal";
            "navBarInline" = false;
            "navBarSide" = "left";
            "hideAddBtn" = false;
            "hideSettingsBtn" = false;
            "navBtnCount" = true;
            "hideEmptyPanels" = false;
            "hideDiscardedTabPanels" = false;
            "navActTabsPanelLeftClickAction" = "none";
            "navActBookmarksPanelLeftClickAction" = "none";
            "navTabsPanelMidClickAction" = "discard";
            "navBookmarksPanelMidClickAction" = "none";
            "navSwitchPanelsWheel" = true;
            "subPanelRecentlyClosedBar" = true;
            "subPanelBookmarks" = true;
            "subPanelHistory" = true;
            "groupLayout" = "grid";
            "containersSortByName" = false;
            "skipEmptyPanels" = false;
            "dndTabAct" = false;
            "dndTabActDelay" = 750;
            "dndTabActMod" = "none";
            "dndExp" = "none";
            "dndExpDelay" = 750;
            "dndExpMod" = "none";
            "dndOutside" = "win";
            "dndActTabFromLink" = true;
            "dndActSearchTab" = true;
            "dndMoveTabs" = false;
            "dndMoveBookmarks" = false;
            "searchBarMode" = "dynamic";
            "searchPanelSwitch" = "any";
            "searchBookmarksShortcut" = "";
            "searchHistoryShortcut" = "";
            "warnOnMultiTabClose" = "any";
            "activateLastTabOnPanelSwitching" = true;
            "activateLastTabOnPanelSwitchingLoadedOnly" = true;
            "switchPanelAfterSwitchingTab" = "always";
            "tabRmBtn" = "hover";
            "activateAfterClosing" = "prev_act";
            "activateAfterClosingStayInPanel" = true;
            "activateAfterClosingGlobal" = false;
            "activateAfterClosingNoFolded" = true;
            "activateAfterClosingNoDiscarded" = true;
            "askNewBookmarkPlace" = true;
            "tabsRmUndoNote" = true;
            "tabsUnreadMark" = false;
            "tabsUpdateMark" = "pin";
            "tabsUpdateMarkFirst" = true;
            "tabsReloadLimit" = 5;
            "tabsReloadLimitNotif" = true;
            "showNewTabBtns" = true;
            "newTabBarPosition" = "after_tabs";
            "tabsPanelSwitchActMove" = true;
            "tabsPanelSwitchActMoveAuto" = true;
            "tabsUrlInTooltip" = "full";
            "newTabCtxReopen" = false;
            "tabWarmupOnHover" = true;
            "tabSwitchDelay" = 0;
            "moveNewTabPin" = "start";
            "moveNewTabParent" = "first_child";
            "moveNewTabParentActPanel" = false;
            "moveNewTab" = "end";
            "moveNewTabActivePin" = "start";
            "pinnedTabsPosition" = "top";
            "pinnedTabsList" = false;
            "pinnedAutoGroup" = false;
            "pinnedNoUnload" = false;
            "pinnedForcedDiscard" = false;
            "tabsTree" = true;
            "groupOnOpen" = true;
            "tabsTreeLimit" = "none";
            "autoFoldTabs" = false;
            "autoFoldTabsExcept" = "none";
            "autoExpandTabs" = false;
            "autoExpandTabsOnNew" = true;
            "rmChildTabs" = "folded";
            "tabsLvlDots" = false;
            "discardFolded" = true;
            "discardFoldedDelay" = 30;
            "discardFoldedDelayUnit" = "sec";
            "tabsTreeBookmarks" = true;
            "treeRmOutdent" = "branch";
            "autoGroupOnClose" = false;
            "autoGroupOnClose0Lvl" = false;
            "autoGroupOnCloseMouseOnly" = false;
            "ignoreFoldedParent" = false;
            "showNewGroupConf" = true;
            "sortGroupsFirst" = true;
            "colorizeTabs" = true;
            "colorizeTabsSrc" = "container";
            "colorizeTabsBranches" = false;
            "colorizeTabsBranchesSrc" = "url";
            "inheritCustomColor" = false;
            "previewTabs" = false;
            "previewTabsMode" = "p";
            "previewTabsPageModeFallback" = "i";
            "previewTabsInlineHeight" = 70;
            "previewTabsPopupWidth" = 280;
            "previewTabsSide" = "right";
            "previewTabsDelay" = 500;
            "previewTabsFollowMouse" = true;
            "previewTabsWinOffsetY" = 36;
            "previewTabsWinOffsetX" = 6;
            "previewTabsInPageOffsetY" = 0;
            "previewTabsInPageOffsetX" = 0;
            "previewTabsCropRight" = 0;
            "hideInact" = false;
            "hideFoldedTabs" = false;
            "hideFoldedParent" = "none";
            "nativeHighlight" = false;
            "warnOnMultiBookmarkDelete" = "any";
            "autoCloseBookmarks" = false;
            "autoRemoveOther" = false;
            "highlightOpenBookmarks" = true;
            "activateOpenBookmarkTab" = true;
            "showBookmarkLen" = true;
            "bookmarksRmUndoNote" = true;
            "loadBookmarksOnDemand" = true;
            "pinOpenedBookmarksFolder" = true;
            "oldBookmarksAfterSave" = "ask";
            "loadHistoryOnDemand" = true;
            "fontSize" = "m";
            "animations" = true;
            "animationSpeed" = "fast";
            "theme" = "proton";
            "density" = "default";
            "colorScheme" = "ff";
            "sidebarCSS" = false;
            "groupCSS" = false;
            "snapNotify" = true;
            "snapExcludePrivate" = true;
            "snapInterval" = 1;
            "snapIntervalUnit" = "day";
            "snapLimit" = 3;
            "snapLimitUnit" = "day";
            "snapAutoExport" = false;
            "snapAutoExportType" = "json";
            "snapAutoExportPath" = "Sidebery/snapshot-%Y.%M.%D-%h.%m.%s";
            "snapMdFullTree" = true;
            "hScrollAction" = "switch_panels";
            "onePanelSwitchPerScroll" = true;
            "wheelAccumulationX" = true;
            "wheelAccumulationY" = true;
            "navSwitchPanelsDelay" = 250;
            "scrollThroughTabs" = "none";
            "scrollThroughVisibleTabs" = true;
            "scrollThroughTabsSkipDiscarded" = true;
            "scrollThroughTabsExceptOverflow" = true;
            "scrollThroughTabsCyclic" = true;
            "scrollThroughTabsScrollArea" = 0;
            "autoMenuMultiSel" = true;
            "multipleMiddleClose" = true;
            "longClickDelay" = 500;
            "wheelThreshold" = false;
            "wheelThresholdX" = 10;
            "wheelThresholdY" = 60;
            "tabDoubleClick" = "edit_title";
            "tabsSecondClickActPrev" = false;
            "tabsSecondClickActPrevPanelOnly" = false;
            "shiftSelAct" = false;
            "activateOnMouseUp" = true;
            "tabLongLeftClick" = "reload";
            "tabLongRightClick" = "reload";
            "tabMiddleClick" = "close";
            "tabMiddleClickCtrl" = "discard";
            "tabMiddleClickShift" = "none";
            "tabCloseMiddleClick" = "discard";
            "tabsPanelLeftClickAction" = "none";
            "tabsPanelDoubleClickAction" = "undo";
            "tabsPanelRightClickAction" = "menu";
            "tabsPanelMiddleClickAction" = "tab";
            "newTabMiddleClickAction" = "new_child";
            "bookmarksLeftClickAction" = "open_in_new";
            "bookmarksLeftClickActivate" = true;
            "bookmarksLeftClickPos" = "default";
            "bookmarksMidClickAction" = "open_in_new";
            "bookmarksMidClickActivate" = false;
            "bookmarksMidClickRemove" = false;
            "bookmarksMidClickPos" = "default";
            "historyLeftClickAction" = "open_in_new";
            "historyLeftClickActivate" = true;
            "historyLeftClickPos" = "default";
            "historyMidClickAction" = "open_in_new";
            "historyMidClickActivate" = false;
            "historyMidClickPos" = "default";
            "syncName" = "";
            "syncSaveSettings" = true;
            "syncSaveCtxMenu" = true;
            "syncSaveStyles" = true;
            "syncSaveKeybindings" = true;
            "selectActiveTabFirst" = true;
          };
          "sidebar" = {
            "nav" = [
              "search"
              "sp-q5-_0A3T8B8b"
              "thYTnQznT_5_"
              "Sm6-gurlI9Rn"
              "zLIT4NTAh4mm"
              "sp-pVOFdoIS_UVx"
              "add_tp"
            ];
            "panels" = {
              "thYTnQznT_5_" = {
                "type" = 2;
                "id" = "thYTnQznT_5_";
                "name" = "lil chill";
                "color" = "toolbar";
                "iconSVG" = "icon_tabs";
                "iconIMGSrc" = "";
                "iconIMG" = "";
                "lockedPanel" = false;
                "skipOnSwitching" = false;
                "noEmpty" = true;
                "newTabCtx" = "none";
                "dropTabCtx" = "none";
                "moveRules" = [ ];
                "moveExcludedTo" = -1;
                "bookmarksFolderId" = -1;
                "newTabBtns" = [ ];
                "srcPanelConfig" = null;
              };
              "Sm6-gurlI9Rn" = {
                "type" = 2;
                "id" = "Sm6-gurlI9Rn";
                "name" = "coding eee";
                "color" = "orange";
                "iconSVG" = "icon_code";
                "iconIMGSrc" = "";
                "iconIMG" = "";
                "lockedPanel" = false;
                "skipOnSwitching" = false;
                "noEmpty" = true;
                "newTabCtx" = "none";
                "dropTabCtx" = "none";
                "moveRules" = [ ];
                "moveExcludedTo" = -1;
                "bookmarksFolderId" = -1;
                "newTabBtns" = [ ];
                "srcPanelConfig" = null;
              };
              "zLIT4NTAh4mm" = {
                "type" = 2;
                "id" = "zLIT4NTAh4mm";
                "name" = "something else";
                "color" = "turquoise";
                "iconSVG" = "icon_books";
                "iconIMGSrc" = "";
                "iconIMG" = "";
                "lockedPanel" = false;
                "skipOnSwitching" = false;
                "noEmpty" = true;
                "newTabCtx" = "none";
                "dropTabCtx" = "none";
                "moveRules" = [ ];
                "moveExcludedTo" = -1;
                "bookmarksFolderId" = -1;
                "newTabBtns" = [ ];
                "srcPanelConfig" = null;
              };
            };
          };
          "contextMenu" = {
            "tabs" = [
              {
                "opts" = [
                  "undoRmTab"
                  "mute"
                  "reload"
                  "bookmark"
                ];
              }
              "separator-1"
              {
                "name" = "%menu.tab.reopen_in_sub_menu_name";
                "opts" = [
                  "reopenInNewWin"
                  "reopenInWin"
                  "reopenInCtr"
                ];
              }
              {
                "name" = "%menu.tab.colorize_";
                "opts" = [
                  "colorizeTab"
                ];
              }
              "separator-2"
              "pin"
              "duplicate"
              "discard"
              "copyTabsTitles"
              "separator-3"
              "group"
              "flatten"
              "separator-4"
              "urlConf"
              "clearCookies"
              "close"
            ];
            "tabsPanel" = [
              {
                "opts" = [
                  "undoRmTab"
                  "muteAllAudibleTabs"
                  "reloadTabs"
                  "discardTabs"
                ];
              }
              "separator-7"
              "selectAllTabs"
              "collapseInactiveBranches"
              "closeTabsDuplicates"
              "closeTabs"
              "separator-8"
              "openPanelConfig"
            ];
            "bookmarks" = [
              {
                "name" = "%menu.bookmark.open_in_sub_menu_name";
                "opts" = [
                  "openInNewWin"
                  "openInNewPrivWin"
                  "separator-9"
                  "openInPanel"
                  "openInNewPanel"
                  "separator-10"
                  "openInCtr"
                ];
              }
              {
                "name" = "%menu.bookmark.sort_sub_menu_name";
                "opts" = [
                  "sortByNameAscending"
                  "sortByNameDescending"
                  "sortByLinkAscending"
                  "sortByLinkDescending"
                  "sortByTimeAscending"
                  "sortByTimeDescending"
                ];
              }
              "separator-5"
              "createBookmark"
              "createFolder"
              "createSeparator"
              "separator-8"
              "openAsBookmarksPanel"
              "openAsTabsPanel"
              "separator-7"
              "copyBookmarksUrls"
              "copyBookmarksTitles"
              "moveBookmarksTo"
              "edit"
              "delete"
            ];
            "bookmarksPanel" = [
              "collapseAllFolders"
              "switchViewMode"
              "convertToTabsPanel"
              "separator-9"
              "unloadPanelType"
              "openPanelConfig"
              "hidePanel"
              "removePanel"
            ];
          };
          "ver" = "5.2.0";
        };
      };
    };
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

    "browser.search.defaultenginename" = "DuckDuckGo";
    "browser.search.order.1" = "DuckDuckGo";
    "browser.aboutConfig.showWarning" = false;
    "browser.compactmode.show" = true;

    "extensions.activeThemeID" = customAddons.rose-pine-moon-modified.addonId;
  };
in
{
  options.modules.shyfox = {
    enable = mkEnableOption "shyfox";
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
          settings = settings // shyfox-settings;
          userChrome = builtins.readFile "${pkgs.shyfox}/chrome/userChrome.css";
          userContent = builtins.readFile "${pkgs.shyfox}/chrome/userContent.css";
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

    home.file.".mozilla/firefox/default/chrome/ShyFox".source = "${pkgs.shyfox}/chrome/ShyFox";
    home.file.".mozilla/firefox/default/chrome/icons".source = "${pkgs.shyfox}/chrome/icons";
  };
}
