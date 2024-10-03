{ config, lib, inputs, ...}:

{
    imports = [ ../../modules/default.nix ];
    config.modules = {
        # gui
        hyprland.enable = true;
        rofi.enable = true;
        styling.enable = true;
        fuzzel.enable = true;

        # cli
        terminal.enable = true;

        # dev
        vscode.enable = true;
        
        # system
        xdg.enable = true;
        packages.enable = true;

        # Work
        work-packages.enable = true;
        vm-windows.enable = true;

        # Social
        social.enable = true;

        # Media
		media.enable = true;
    };
}
