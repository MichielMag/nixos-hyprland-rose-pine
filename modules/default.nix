{ inputs, pkgs, config, ... }:

{
    home.stateVersion = "21.03";
    imports = [
        # gui
        #./firefox
        #./foot
        #./eww
        #./dunst
        ./hyprland
        ./rofi
        ./swaylock
        #./wofi

        # cli
        ./terminal
        #./nvim
        #./zsh
        #./git
        #./gpg
        #./direnv

        ./vscode

        # system
        ./xdg
	    ./packages
        ./work-packages
        ./styling
    ];    
}