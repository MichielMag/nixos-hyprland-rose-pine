{
  config,
  lib,
  inputs,
  ...
}:

{
  imports = [ ../../modules/home/default.nix ];
  config = {

    modules = {
      # gui
      hyprland.enable = true;
      waybar.enable = true;
      rofi.enable = true;
      styling.enable = true;
      fuzzel.enable = true;
      terminal.enable = true;
      swaync.enable = true;
      swayosd.enable = true;
      wlogout.enable = true;
      wlsunset.enable = true;
      ulauncher.enable = true;
      nwg-dock-hyprland.enable = true;

      # graphics
      gimp.enable = true;

      # networking
      #onedrive = {
      #  enable = true;
      #  configFiles."4dotnet" = ./.config/onedrive;
      #};
      firefox = {
        enable = true;
        pwa = {
          "whatsapp" = {
            url = "https://web.whatsapp.com";
            profileId = 2;
            icon = "whatsapp";
            name = "WhatsApp Web";
            genericName = "WhatsApp Instant Messaging";
          };
          "teams" = {
            url = "https://teams.live.com";
            profileId = 3;
            icon = "teams-for-linux";
            name = "Teams";
            genericName = "Teams Instant Messaging";
          };
        };
      };

      # office
      obsidian.enable = true;

      # dev
      vscode.enable = true;
      direnv.enable = true;
      git = {
        user = "MichielMag";
        email = "michiel_m@live.nl";
        enable = true;
      };
      #jetbrains-rider.enable = true;
      #bruno.enable = true; # Won't work in wayland for now

      # system
      xdg.enable = true;
      packages.enable = true;
      keyring.enable = true;

      # Social
      social.enable = true;

      # Media
      spotify.enable = true;
    };
  };
}
