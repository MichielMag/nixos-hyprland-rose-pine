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

      # graphics
      gimp.enable = true;

      # networking
      onedrive = {
        enable = false;
        configFiles."4dotnet" = ./.config/onedrive;
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
      insomnia.enable = true;
      jetbrains-rider.enable = true;
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
      media.enable = true;

    };
  };
}
