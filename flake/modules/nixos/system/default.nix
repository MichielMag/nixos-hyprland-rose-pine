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
    acpi
    tlp
    git
    alsa-utils
    libnotify
    wtype
    zip
    traceroute
    wev
    nvtopPackages.full
    freerdp
    wget
    gparted
    #networkmanager
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

  # Nix settings, auto cleanup and enable flakes
  nix = {
    settings.auto-optimise-store = true;
    settings.allowed-users = [ "michiel" ];
    settings.trusted-users = [ "michiel" ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  # Boot settings: clean /tmp/, latest kernel and enable bootloader
  boot = {
    tmp = {
      cleanOnBoot = true;
    };
    loader = {
      systemd-boot.enable = true;
      systemd-boot.editor = false;
      efi.canTouchEfiVariables = true;
      timeout = 5;
    };
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

  # Set up locales (timezone and keyboard layout)
  time.timeZone = "Europe/Amsterdam";
  time.hardwareClockInLocalTime = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Default programs
  programs.fish.enable = true;
  programs.thunar.enable = true;
  programs.dconf.enable = true;
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
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
  programs.partition-manager.enable = true;

  # Set up user and enable sudo
  users.users.michiel = {
    isNormalUser = true;
    extraGroups = [
      "input"
      "wheel"
      "networkmanager"
      "ydotool"
      "video"
      "render"
      "pipewire"
      "docker"
    ];
    shell = pkgs.fish;
  };

  # Set up networking and secure it
  networking = {
    wireless.iwd.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [
        443
        80
        22
        22220
      ];
      allowedUDPPorts = [
        443
        80
        44857
      ];
      allowPing = false;
    };
    enableIPv6 = false;
    networkmanager.enable = true;
    networkmanager.wifi.backend = "iwd";
  };

  services.openssh.enable = true;

  # Set environment variables
  environment.variables = {
    DOT_CONFIG = "$HOME/.config";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    XDG_SESSION_TYPE = "wayland";
    QT_QPA_PLATFORM = "wayland";
    GTK_USE_PORTAL = "1";
    NIXOS_XDG_OPEN_USE_PORTAL = "1";
    XDG_CURRENT_DESKTOP = "Hyprland";
  };

  # Security
  security = {
    sudo.enable = true;
    protectKernelImage = true;
    polkit.enable = true;
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
    #doesnt work for now
    #alsa.enablePersistence = true;
  };

  # Virtualisation
  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = false;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  virtualisation.docker.daemon.settings = {
    data-root = "/data/docker";
  };

  # This value determines the NixOS release from which the default
  system.stateVersion = "24.05"; # Did you read the comment?

  # Gaming mouse config
  services.ratbagd.enable = true;

  # Install fonts
  fonts = {
    packages = with pkgs; [
      jetbrains-mono
      roboto
      openmoji-color
      nerd-fonts.jetbrains-mono
    ];

    fontconfig = {
      hinting.autohint = true;
      defaultFonts = {
        emoji = [ "OpenMoji Color" ];
      };
    };
  };

  console.colors = [
    "232136" # base00-hex

    "eb6f92" # red
    "3e8fb0" # green
    "f6c177" # yellow
    "9ccfd8" # blue
    "c4a7e7" # magenta
    "ea9a97" # cyan

    "e0def4" # base05-hex
    "6e6a86" # base03-hex

    "f6c177" # red
    "3e8fb0" # green
    "eb6f92" # yellow
    "9ccfd8" # blue
    "c4a7e7" # magenta
    "ea9a97" # cyan

    "e0def4" # base06-hex
  ];

}
