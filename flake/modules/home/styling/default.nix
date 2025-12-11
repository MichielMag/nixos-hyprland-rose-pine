{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.styling;
in
#kvconfig = config.lib.stylix.colors {
#  template = ./assets/kvconfig.mustache;
#  extension = ".kvconfig";
#};
#svg = config.lib.stylix.colors {
#  template = ./assets/kvantum-svg.mustache;
#  extension = "svg";
#};
#kvantumPackage = pkgs.runCommandLocal "base16-kvantum" { } ''
#  directory="$out/share/Kvantum/Base16Kvantum"
#  mkdir --parents "$directory"
#  cat ${kvconfig} >>"$directory/Base16Kvantum.kvconfig"
#  cat ${svg} >>"$directory/Base16Kvantum.svg"
#'';
{
  options.modules.styling = {
    enable = mkEnableOption "styling";
  };
  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      libsForQt5.qt5ct
      libsForQt5.qtstyleplugin-kvantum
      qt6Packages.qtstyleplugin-kvantum
      rose-pine-cursor
      rose-pine-icon-theme
      rose-pine-gtk-theme
      zafiro-icons
    ];

    #home.file.".config/Kvantum" = {
    #    source = ./.config/Kvantum;
    #    recursive = true;
    #};
    #
    #qt = {
    #  enable = true;
    #  platformTheme.name = "qtct";
    #};

    #xdg.configFile."Kvantum/kvantum.kvconfig".source =
    #  (pkgs.formats.ini { }).generate "kvantum.kvconfig"
    #    {
    #      General.theme = "Base16Kvantum";
    #    };
    #
    #xdg.configFile."Kvantum/Base16Kvantum".source = "${kvantumPackage}/share/Kvantum/Base16Kvantum";
    #
    #xdg.configFile."qt5ct/qt5ct.conf".text = ''
    #  [Appearance]
    #  style=kvantum
    #  icon_theme=Papirus
    #'';
    #
    #xdg.configFile."qt6ct/qt6ct.conf".text = ''
    #  [Appearance]
    #  style=kvantum
    #  icon_theme=Papirus
    #'';

    gtk = {
      enable = true;
      theme = {
        name = "Nordic";
        package = pkgs.nordic;
      };
      font = {
        name = "JetBrains Mono Regular";
        package = pkgs.jetbrains-mono;
      };
      iconTheme = {
        name = "Zafiro-icons-Dark";
        package = pkgs.zafiro-icons;
      };
      cursorTheme = {
        name = "BreezeX-RosePine-Linux";
        package = pkgs.rose-pine-cursor;
        size = 24;
      };
      gtk3 = {
        bookmarks = [
          "file://${config.xdg.userDirs.documents}"
          "file://${config.xdg.userDirs.download} downloads"
          "file://${config.xdg.userDirs.pictures}"
          "file://${config.xdg.userDirs.extraConfig.source}"
        ];
      };
    };
    dconf.settings = {
      "org/gnome/desktop/wm/preferences".button-layout = "appmenu";
      "org/gnome/desktop/interface".color-scheme = "prefer-dark";
    };
    #programs.gnome-shell = {
    #    enable = true;
    #    theme = {
    #        name = "rose-pine-moon";
    #        package = pkgs.rose-pine-gtk-theme;
    #    };
    #};

    #stylix = {
    #  enable = false;
    #  autoEnable = false;
    #  base16Scheme = ./.config/stylix/rose-pine-moon.yaml;
    #  image = ./.config/stylix/wallpaper.png;
    #  polarity = "dark";
    #  targets = {
    #    #gtk.enable = true;
    #    #gnome.enable = true;
    #    #kde.enable = true;
    #    #xfce.enable = true;
    #    #btop.enable = true;
    #  };
    #  cursor = {
    #    name = "BreezeX-RosePine-Linux";
    #    package = pkgs.rose-pine-cursor;
    #    size = 24;
    #  };
    #};
  };
}
