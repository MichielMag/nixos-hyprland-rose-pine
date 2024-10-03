{ inputs, pkgs, config, ... }:

{
    home.stateVersion = "21.03";
    imports = [

        ./quickemu
        
        # gui
        ./hyprland
        ./rofi
        ./styling
        ./fuzzel

        # cli
        ./terminal

        # dev
        ./vscode

        # system
        ./xdg
	    ./packages

        # Work
        ./work-packages
        ./vm-windows

        # Social
        ./social

        # Media
        ./media

    ];    
}