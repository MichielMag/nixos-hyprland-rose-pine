{
  inputs,
  pkgs,
  config,
  ...
}:

{
  imports = [
    ./office/evolution
    ./office/gaming/steam
  ];

}
