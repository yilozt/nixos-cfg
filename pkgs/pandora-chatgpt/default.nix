{ lib, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "Pandora-ChatGPT";
  version = "1.0.6";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256-LtaRWVNG9VBO0LmCQTIL9nuYK6IwrVP2PRFdCQ+w9Zc=";
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
    pyperclip
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
