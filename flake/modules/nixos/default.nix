{
  inputs,
  pkgs,
  config,
  ...
}:

{
  imports = [
    ./office/evolution
    ./gaming/steam
    ./ai/ollama
  ];

}
