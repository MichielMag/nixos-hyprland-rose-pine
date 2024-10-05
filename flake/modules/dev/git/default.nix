{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.git;

in
{
  options.modules.git = {
    enable = mkEnableOption "git";
    user = mkOption {
      type = types.str;
      description = ''
        Username to use
      '';
    };
    email = mkOption {
      type = types.str;
      description = ''
        Language to use
      '';
    };
  };
  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = user;
      userEmail = email;
      extraConfig = {
        push = {
          autoSetupRemote = true;
        };
      };
    };
    programs.git-credential-oauth.enable = true;
  };
}
