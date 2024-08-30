{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.styling;

in {
    options.modules.styling = { enable = mkEnableOption "styling"; };
    config = mkIf cfg.enable {

        #catppuccin.enable = true;
        #catppuccin.flavor = "macchiato";
             
        #home.packages = with pkgs; [
        #    (catppuccin-kvantum.override {
        #        accent = "Blue";
        #        variant = "Mocha";
        #    })
        #    libsForQt5.qtstyleplugin-kvantum
        #    papirus-folders
        #];

        #home.sessionVariables = {
        #    GTK_THEME = "rose-pine-gtk-theme";
        #    ICON_THEME = "rose-pine-icon-theme";
        #    CURSOR_THEME = "rose-pine-cursor";
        #};

        #dconf.settings = {
        #    "org/gnome/desktop/interface" = {
        #        gtk-theme = "rose-pine-gtk-theme";
        #        color-scheme = "prefer-dark";
        #    };
        #    "org/gnome/shell/extensions/user-theme" = {
        #        name = "rose-pine-gtk-theme";
        #    };
        #};
#   
        qt = {
            enable = true;
            #catppuccin.enable = true;
        };
        gtk = {
            enable = true;
            #catppuccin.enable = true;
        };
        #    theme = {
        #        name = "rose-pine-gtk-theme";
        #        package = pkgs.rose-pine-gtk-theme;
        #    };
        #    iconTheme = {
        #        name = "rose-pine-icon-theme";
        #        package = pkgs.rose-pine-icon-theme;
        #    };
        #    cursorTheme = {
        #        name = "rose-pine-cursor";
        #        package = pkgs.rose-pine-cursor;
        #    };
        #    gtk3 = {
        #        extraConfig.gtk-application-prefer-dark-theme = true;
        #    };
        #    #cursorTheme.name = "rose-pine-cursor";
        #    #cursorTheme.package = pkgs.rose-pine-cursor;
        #};
        #stylix.targets = {
        #    kitty.enable = false;
        #    fish.enable = false;
        #    gnome.enable = false;
        #    gtk.enable = false;
        #    hyprland.enable = false;
        #    kde.enable = true;
        #    dunst.enable = false;
        #    rofi.enable = false;
        #    swaylock.enable = false;
        #    waybar.enable = false;
        #    vscode.enable = false;
        #};
    };
}
