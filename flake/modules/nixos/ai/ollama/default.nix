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
  options.modules.ollama = {
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
      home = "/home/ollama";
      models = "/home/ollama/models";
      port = 11434;
    };

    users.groups.ollama = { };
    users.users.ollama = {
      isNormalUser = false;
      createHome = true;
      home = "/home/ollama";
      group = "ollama";

      shell = pkgs.fish;
    };
  };
}
