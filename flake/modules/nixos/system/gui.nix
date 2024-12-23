{
  config,
  pkgs,
  inputs,
  ...
}:

{
  # Remove unecessary preinstalled packages
  environment.defaultPackages = [

  ];

  # Laptop-specific packages (the other ones are installed in `packages.nix`)
  environment.systemPackages = with pkgs; [
    alsa-utils
    libnotify
    wtype
    nvtopPackages.full
  ];

  # Wayland stuff: enable XDG integration, allow sway to use brillo
  xdg = {
    autostart.enable = true;
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };
  };

  services = {
    dbus.enable = true;
    libinput.enable = true;
    displayManager.ly = {
      enable = true;
      settings.animation = "matrix";
    };
    xserver = {
      enable = true;
      desktopManager = {
        xterm.enable = false;
      };
      updateDbusEnvironment = true;
      videoDrivers = [
        "displaylink"
        "modesetting"
      ];
    };
  };

  # Boot settings: clean /tmp/, latest kernel and enable bootloader
  boot = {
    plymouth = {
      enable = true;
      theme = "spin";
      themePackages = with pkgs; [
        # By default we would install all themes
        (adi1090x-plymouth-themes.override {
          selected_themes = [
            "angular"
            "colorful_loop"
            "circle_flow"
            "hexa_retro"
            "spin"
          ];
        })
      ];
    };
  };

  # Default programs
  programs.thunar.enable = true;
  programs.hyprland.enable = true;
  programs.ydotool = {
    enable = true;
    group = "ydotool";
  };
  programs.ssh = {
    startAgent = true;
    agentTimeout = "1h";
  };
  programs.nix-ld = {
    enable = true;
  };

  # Set up user and enable sudo
  users.users.michiel.extraGroups = [
    "input"
    "wheel"
    "networkmanager"
    "ydotool"
    "video"
    "render"
    "pipewire"
    "docker"
  ];
  users.users.michiel.shell = pkgs.fish;

  # Set environment variables
  environment.variables = {
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    XDG_SESSION_TYPE = "wayland";
    QT_QPA_PLATFORM = "wayland";
    GTK_USE_PORTAL = "1";
    NIXOS_XDG_OPEN_USE_PORTAL = "1";
    XDG_CURRENT_DESKTOP = "Hyprland";
  };

  # Security 
  security = {
    pam.services = {
      swaylock = { };
      ly = {
        enableGnomeKeyring = true;
      };
    };
  };

  services.gnome.gnome-keyring.enable = true;

  # Audio
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # ALSA provides a udev rule for restoring volume settings.
  services.udev.packages = [ pkgs.alsa-utils ];

  systemd.services.alsa-store = {
    description = "Store Sound Card State";
    wantedBy = [ "multi-user.target" ];
    unitConfig.RequiresMountsFor = "/var/lib/alsa";
    unitConfig.ConditionVirtualization = "!systemd-nspawn";
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.coreutils}/bin/mkdir -p /var/lib/alsa";
      ExecStop = "${pkgs.alsa-utils}/sbin/alsactl store --ignore";
    };
  };

  # Say yes to a GUI
  hardware = {
    graphics.enable = true;
  };

  # Gaming mouse config
  services.ratbagd.enable = true;
}
