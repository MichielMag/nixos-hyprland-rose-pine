{ config, lib, inputs, ...}:

{
    imports = [ ../../modules/default.nix ];
    config.modules = {
        # gui
        #firefox.enable = true;
        #foot.enable = true;
        #eww.enable = true;
        #dunst.enable = true;
        hyprland.enable = true;
        rofi.enable = true;
        swaylock.enable = true;
        #wofi.enable = true;

        # cli
        terminal.enable = true;
        #nvim.enable = true;
        #zsh.enable = true;
        #git.enable = true;
        #gpg.enable = true;
        #direnv.enable = true;

        # system
        xdg.enable = true;
        packages.enable = true;
        styling.enable = true;
    };
}
