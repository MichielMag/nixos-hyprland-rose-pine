{ inputs, pkgs, config, ... }:

{
    home.stateVersion = "21.03";
    imports = [
        # gui
        ./hyprland
        ./rofi
        ./styling

        # cli
        ./terminal

        # dev
        ./vscode

        # system
        ./xdg
	    ./packages

        # Work
        ./work-packages

        # Social
        ./social

        # Media
        ./media
    ];    
}