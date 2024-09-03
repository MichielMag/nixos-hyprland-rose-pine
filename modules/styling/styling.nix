{config, pkgs, inputs, ...}:

{
    environment.systemPackages = with pkgs; [
            libsForQt5.qtstyleplugin-kvantum
            libsForQt5.qt5ct
            kdePackages.qt6ct
            rose-pine-cursor
            rose-pine-icon-theme
            inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
    ];

    # Install fonts
    fonts = {
        packages = with pkgs; [
            jetbrains-mono
            roboto
            openmoji-color
            (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
        ];

        fontconfig = {
            hinting.autohint = true;
            defaultFonts = {
              emoji = [ "OpenMoji Color" ];
            };
        };
    };

    console.colors = [
            "232136"
            "2a273f"
            "393552"
            "6e6a86"
            "908caa"
            "e0def4"
            "e0def4"
            "56526e"
            "eb6f92"
            "f6c177"
            "ea9a97"
            "3e8fb0"
            "9ccfd8"
            "c4a7e7"
            "f6c177"
            "56526e"
    ];

    # catppuccin.flavor = "macchiato";
    # catppuccin.enable = true; 

    #stylix = {
    #    enable = true;
    #    image = ./wallpaper.png;
    #    polarity = "dark";
    #    base16Scheme = {
    #        scheme = "Rosé Pine Moon";
    #        author = "Emilia Dunfelt <edun@dunfelt.se>";
    #        base00 = "232136";
    #        base01 = "2a273f";
    #        base02 = "393552";
    #        base03 = "6e6a86";
    #        base04 = "908caa";
    #        base05 = "e0def4";
    #        base06 = "e0def4";
    #        base07 = "56526e";
    #        base08 = "eb6f92";
    #        base09 = "f6c177";
    #        base0A = "ea9a97";
    #        base0B = "3e8fb0";
    #        base0C = "9ccfd8";
    #        base0D = "c4a7e7";
    #        base0E = "f6c177";
    #        base0F = "56526e";
    #    };
#
    #    cursor = {
    #        name = "rose-pine-cursor";
    #        package = pkgs.rose-pine-cursor;
    #    };
#
    #    opacity = {
    #        terminal = 0.9;
    #        desktop = 0.9;
    #        applications = 0.95;
    #    };
#
    #    fonts = {
    #        serif = {
    #            package = pkgs.roboto;
    #            name = "Roboto";
    #        };
    #        sansSerif = {
    #            package = pkgs.roboto;
    #            name = "Roboto";
    #        };
    #        monospace = {
    #            package = pkgs.jetbrains-mono;
    #            name = "JetBrainsMono Nerd Font";
    #        };
    #        emoji = {
    #            package = pkgs.openmoji-color;
    #            name = "OpenMoji Color";
    #        };
    #    };
#
    #    targets = {
    #        fish.enable = false;
    #        gnome.enable = false;
    #        gtk.enable = false;
    #    };
    #};
}