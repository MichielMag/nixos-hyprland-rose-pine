{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.ollama;

in
{
  options.modules.evolution = {
    enable = mkEnableOption "ollama";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      oterm
    ];
    services.ollama = {
      enable = true;
      acceleration = "cuda";
      user = "ollama";
      group = "ollama";
      home = /home/ollama;
      models = /home/ollama/models;
      port = 11434;
    };
    services.open-webui = {
      enable = true;
      environment = {
        ANONYMIZED_TELEMETRY = "False";
        DO_NOT_TRACK = "True";
        SCARF_NO_ANALYTICS = "True";
        OLLAMA_API_BASE_URL = "http://127.0.0.1:11434/api";
        OLLAMA_BASE_URL = "http://127.0.0.1:11434";
      };
    };

    users.groups.ollama = {
      description = "Ollama's group";
    };
    users.users.ollama = {
      isNormalUser = false;
      createHome = true;
      home = /home/ollama;
      group = "ollama";
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
  };
}
