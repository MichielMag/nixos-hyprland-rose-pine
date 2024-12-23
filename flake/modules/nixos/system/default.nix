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
    zip
    traceroute
    wev
    wget
  ];

  services = {
    libinput.enable = true;
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
  programs.dconf.enable = true;
  programs.ssh = {
    startAgent = true;
    agentTimeout = "1h";
  };
  programs.nix-ld = {
    enable = true;
  };

  # Set up user and enable sudo
  users.users.michiel = {
    isNormalUser = true;
    extraGroups = [
      "input"
      "wheel"
      "networkmanager"
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
  };

  # Security 
  security = {
    sudo.enable = true;
    protectKernelImage = true;
  };

  services.gnome.gnome-keyring.enable = true;

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
}
