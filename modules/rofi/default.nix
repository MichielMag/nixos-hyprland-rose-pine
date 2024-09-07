{ pkgs, lib, config, ... }:

with lib;
let 
    cfg = config.modules.rofi;
    adi1090x-rofi = pkgs.fetchFromGitHub {
        owner = "MichielMag";
        repo = "adi1090x-rofi";
        rev = "e13471745d2b825baf5a82173f9d126512379a8c";
        sha256 = "08g2bvciy2mg5fkvhz3x06im5ayrcaihixghnzxkg8jhwk5dzpxb";
    };
in {
    options.modules.rofi = { enable = mkEnableOption "rofi"; };

    config = mkIf cfg.enable {

        home.packages = with pkgs; [
            rofi-wayland
            update-nix-fetchgit
        ];

        programs.rofi = {
            enable = true;
            package = pkgs.rofi-wayland;
            theme = ./.config/rofi/rose-pine.rasi;
            extraConfig = {
                show-icons = true;
                sidebar-mode = true;
                icon-theme = "Flat-Remix-Blue-Dark";
                font = "SFNS Display 13";
            };
            terminal = "kitty";
        };

        home.file.".config/rofi/adi1090x" = {
            source = "${adi1090x-rofi}/files";
            recursive = true;
            target = ".config/rofi/adi1090x";
        };

        home.file.".local/share/fonts" = {
            source = "${adi1090x-rofi}/fonts";
            recursive = true;
        };
    };
}
