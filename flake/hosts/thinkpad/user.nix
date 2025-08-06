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

      # creative
      gimp.enable = true;
      krita.enable = true;
      blockbench.enable = true;
      #lmms.enable = true;
      freecad.enable = true;
      sweethome3d.enable = true;

      # networking
      #onedrive = {
      #  enable = false;
      #  configFiles."4dotnet" = ./.config/onedrive;
      #};

      # office
      obsidian.enable = true;
      libreoffice.enable = true;

      # dev
      arduino.enable = true;
      vscode.enable = true;
      direnv.enable = true;
      git = {
        user = "MichielMag";
        email = "michiel_m@live.nl";
        enable = true;
      };
      insomnia.enable = true;
      jetbrains-rider.enable = true;
      #godot.enable = true;
      #bruno.enable = true; # Won't work in wayland for now

      # system
      xdg.enable = true;
      packages.enable = true;
      keyring.enable = true;

      # Work
      work-packages.enable = true;
      vm-windows.enable = true;

      # Social
      social.enable = true;

      # Media
      spotify.enable = true;
      tidal.enable = true;

      firefox = {
        enable = true;
        pwa = {
          "teams" = {
            url = "https://teams.live.com";
            profileId = 3;
            name = "Teams";
            icon = "teams-for-linux";
            genericName = "Teams Instant Messaging";
          };
        };
      };

    };
  };
}
