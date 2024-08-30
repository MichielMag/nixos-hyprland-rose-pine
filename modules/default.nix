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
        ./kitty
        ./oh-my-posh
        ./fish
        #./nvim
        #./zsh
        #./git
        #./gpg
        #./direnv

        # system
        ./xdg
	    ./packages
        ./styling
    ];    
}