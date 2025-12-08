{
  inputs,
  pkgs,
  config,
  username,
  ...
}:

{
  home.stateVersion = "21.03";
  home.homeDirectory = "/home/${username}";
  imports = [

    inputs.spicetify-nix.homeManagerModules.default

    ./networking/firefox-pwa

    ./quickemu

    # gui
    ./gui
    ./gui/hyprland
    ./gui/waybar
    ./gui/rofi
    ./gui/fuzzel
    ./gui/terminal
    ./gui/dunst
    ./gui/swaync
    ./gui/swayosd
    ./gui/wlogout
    ./gui/wlsunset
    ./gui/ulauncher
    ./gui/nwg-dock-hyprland

    # creative
    ./creative/gimp
    ./creative/krita
    ./creative/blockbench
    ./creative/lmms
    ./creative/freecad
    ./creative/sweethome3d

    # networking
    ./networking/onedrive
    ./networking/firefox

    # dev
    ./dev/arduino
    ./dev/vscode
    ./dev/git
    ./dev/direnv
    ./dev/insomnia
    ./dev/jetbrains-rider
    ./dev/godot
    ./dev/ldtk

    # office
    ./office/obsidian
    ./office/outlook-pwa
    ./office/libreoffice

    # system
    ./system/xdg
    ./system/packages
    ./system/keyring

    # Work
    ./work-packages
    ./vm-windows

    # Social
    ./social

    # Media
    ./media/spotify
    ./media/tidal

    # Styling
    ./styling

    ./virtualization/bottles

    {
      config.xdg.configFile."nixpkgs/config.nix".text = ''
        {
          allowUnfree = true;
        }
      '';
    }
  ];

}
