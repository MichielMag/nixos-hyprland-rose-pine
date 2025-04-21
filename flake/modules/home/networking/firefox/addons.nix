{ buildFirefoxXpiAddon, lib }:

{
  rose-pine-moon-update = buildFirefoxXpiAddon rec {
    pname = "rose_pine_moon_update";
    version = "1.0";
    addonId = "{a046d296-3ec9-40f8-a15c-db401fb7d8e7}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4150630/${pname}-${version}.xpi";
    sha256 = "sha256-mrAplSCo5w9b6YPzNySGBr0mhApFVNezjbk6IT0hUt0=";
    meta = with lib; {
      homepage = "https://addons.mozilla.org/en-US/firefox/addon/rose-pine-moon-update/";
      description = "rose pine moon with better colouring and more vivid.";
      license = licenses.gpl3;
      platforms = platforms.all;
    };
  };
  userchrome-toggle-extended = buildFirefoxXpiAddon rec {
    pname = "userchrome-toggle-extended";
    version = "2.0.1";
    addonId = "userchrome-toggle-extended@n2ezr.ru";
    url = "https://addons.mozilla.org/firefox/downloads/file/4341014/${pname}-${version}.xpi";
    sha256 = "sha256-P1viaEKEwLeaqtD3CHKofyGpoTKaXq+OYAkObw5qdB0=";
    meta = with lib; {
      homepage = "https://github.com/Naezr/userchrome-toggle-extended-2";
      description = "This extension allows you to toggle userchrome.css styles on-the-fly with buttons and hotkeys. You'll be able to switch up to six styles";
      license = licenses.mpl20;
      platforms = platforms.all;
    };
  };
}
