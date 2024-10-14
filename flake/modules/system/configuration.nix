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
    #networkmanager
  ];

  # Wayland stuff: enable XDG integration, allow sway to use brillo
  xdg = {
    autostart.enable = true;
    portal = {
      #wlr.enable = true;
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        #xdg-desktop-portal-gnome
        #xdg-desktop-portal-wlr
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

      #displayManager.gdm = {
      #    enable = true;
      #    wayland = true;
      #};
      desktopManager = {
        xterm.enable = false;
      };
      updateDbusEnvironment = true;
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

  programs.fish.enable = true;
  programs.thunar.enable = true;
  programs.dconf.enable = true;
  programs.ydotool = {
    enable = true;
    group = "ydotool";
  };

  programs.ssh = {
    startAgent = true;
    agentTimeout = "1h";
  };

  programs.hyprland = {
    enable = true;
    #    portalPackage = pkgs.xdg-desktop-portal-wlr;
  };

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
  };

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
    #doas = {
    #    enable = true;
    #    extraRules = [{
    #        users = [ "michiel" ];
    #        keepEnv = true;
    #        persist = true;
    #    }];
    #};

    # Extra security
    protectKernelImage = true;

    pam.services = {
      swaylock = { };
      ly = {
        enableGnomeKeyring = true;
      };
    };
  };

  services.gnome.gnome-keyring.enable = true;

  #hardware.pulseaudio.enable = true;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    #socketActivation = false;
    #systemWide = true;
  };

  services.openssh.enable = true;

  # Disable bluetooth, enable pulseaudio, enable opengl (for Wayland)
  hardware = {
    graphics = {
      enable = true;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
