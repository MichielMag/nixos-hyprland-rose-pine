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
}
