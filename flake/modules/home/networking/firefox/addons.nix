{ buildFirefoxXpiAddon, lib }:

{
  rose-pine-moon-modified = buildFirefoxXpiAddon rec {
    pname = "rose_pine_moon_modified";
    version = "1.0";
    addonId = "{32aac792-0421-4e99-917a-c849311377ce}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4263824/${pname}-${version}.xpi";
    sha256 = "sha256-NhYo1XukT/eXL8PGnvHs1okArkhOKYAbrzoapAcCFfA=";
    meta = with lib; {
      homepage = "https://addons.mozilla.org/en-US/firefox/addon/rose-pine-moon-modified";
      description = "A modified version of the Rose Pine Moon theme with proper border colors";
      license = licenses.gpl3;
      platforms = platforms.all;
    };
  };
  userchrome-toggle-extended = buildFirefoxXpiAddon rec {
    pname = "userchrome-toggle-extended";
    version = "2.0.1";
    addonId = "userchrome-toggle-extended@n2ezr.ru";
    url = "https://addons.mozilla.org/firefox/downloads/file/4341014/${pname}-${version}.xpi";
    sha256 = "7bld876y3h9c27aypls6ahsj8bzm1r0ixyhmadbgh4489lf4nrz";
    meta = with lib; {
      homepage = "https://github.com/Naezr/userchrome-toggle-extended-2";
      description = "This extension allows you to toggle userchrome.css styles on-the-fly with buttons and hotkeys. You'll be able to switch up to six styles";
      license = licenses.mpl2;
      platforms = platforms.all;
    };
  };
}
