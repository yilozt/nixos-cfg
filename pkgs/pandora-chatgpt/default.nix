{ lib, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "Pandora-ChatGPT";
  version = "1.0.1";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256-2Yym1Mluq0xY1qvOUekfm7ZagrbZaGIJ5Kf1TDRnxwE=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    httpx
    requests
    pyjwt
    appdirs
    werkzeug
    sentry-sdk
    rich
    loguru
    waitress
    flask
    flask-cors
    socksio
    cryptography
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "sentry-sdk~=1.17.0" "sentry-sdk" \
      --replace "rich~=13.3.2" "rich"
  '';

  meta = {
    homepage = "https://github.com/pengzhile/pandora";
    description = "A command-line interface to ChatGPT";
  };
}
