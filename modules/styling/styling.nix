{config, pkgs, inputs, ...}:

{
    environment.systemPackages = with pkgs; [
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
}