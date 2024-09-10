{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.styling;

in {
    options.modules.styling = { enable = mkEnableOption "styling"; };
    config = mkIf cfg.enable {

        home.packages = with pkgs; [
            libsForQt5.qtstyleplugin-kvantum
            rose-pine-cursor
            rose-pine-icon-theme
            rose-pine-gtk-theme
        ];

        home.file.".config/Kvantum" = {
            source = ./.config/Kvantum;
            recursive = true;
        };
#   
        qt = {
            enable = true;
            #style.name = "kvantum";
        };
        
        gtk = {
            enable = true;
            #theme = {
            #    name = "rose-pine-moon";
            #    package = pkgs.rose-pine-gtk-theme;
            #};
            #iconTheme = {
            #    name = "rose-pine-moon";
            #    package = pkgs.rose-pine-icon-theme;
            #};
        };
        programs.gnome-shell = {
        #    enable = true;
        #    theme = {
        #        name = "rose-pine-moon";
        #        package = pkgs.rose-pine-gtk-theme;
        #    };
        };


        stylix = {
            enable = true;
            autoEnable = false;
            base16scheme = ./.config/stylix/rose-pine-moon.yaml;
            image = ./.config/stylix/wallpaper.png;
            polarity = "dark";
            targets = {
                gtk.enable = true;
                gnome.enable = true;
                qt.enable = true;
                kde.enable = true;
                xfce.enable = true;
                btop.enable = true;
            }
        };

        programs.gnome-shell = {
        #    enable = true;
        #    theme = {
        #        name = "rose-pine-moon";
        #        package = pkgs.rose-pine-gtk-theme;
        #    };
        };
    };
}
