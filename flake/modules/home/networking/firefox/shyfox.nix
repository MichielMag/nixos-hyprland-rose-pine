{ lib }:

{
  shyfox-settings = rec {
    settings = {
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # Enable userChrome.css
      "svg.context-properties.content.enabled" = true;
      "layout.css.has-selector.enabled" = true;
      "browser.urlbar.suggest.calculator" = true;
      "browser.urlbar.unitConversion.enabled" = true;
      "browser.urlbar.trimHttps" = true;
      "browser.urlbar.trimURLs" = true;
      "widget.gtk.rounded-bottom-corners.enabled" = true;
      "widget.gtk.ignore-bogus-leave-notify" = true;
    };
    source = lib.fetchFromGitHub {
      owner = "Naezr";
      repo = "ShyFox";
      rev = "6488ff1934c184a7b81770c67f5c3b5e983152e3";
      sha256 = "0rs9bxxrw4wscf4a8yl776a8g880m5gcm75q06yx2cn3lw2b7v22";
    };
  };
}
