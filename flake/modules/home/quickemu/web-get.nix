{ pkgs, ... }:

let
    web_redirect = url: 
    let
        finalUrl = builtins.exec {
            command = "${pkgs.curl}/bin/curl --silent --location --fail --write-out '%{url_effective}' --output /dev/null ${url}";
        };
    in
        if finalUrl != url then finalUrl else url;
in
{
    web_get = { url, dir, file ? null, headers ? [], operation ? null, os ? null, release ? null, edition ? null }:
    let
        userAgent = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36";
        finalUrl = web_redirect url;
        finalFile = if file == null then builtins.baseNameOf url else file;
    in
    {
        url = finalUrl;
        fileName = finalFile;
        iso = pkgs.fetchurl {
            url = finalUrl;
            sha256 = null; # Replace with actual hash if known
            headers = headers;
        };
    }
}