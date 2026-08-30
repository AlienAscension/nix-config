{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "topf";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "postfinance";
    repo = "topf";
    rev = "v${version}";
    hash = "sha256-q9Gr1UuFOxptui6ZOhE0qTMXXVAkLjkAX0n9rzlpaOU=";
  };

  vendorHash = "sha256-TyrlEJjh3SwBaGowM+f096GM2WGfDcxW+RWqspAB7rU=";

  subPackages = [ "cmd/topf" ];

  meta = with lib; {
    description = "Talos Orchestrator by PostFinance";
    homepage = "https://github.com/postfinance/topf";
    license = licenses.mit;
    mainProgram = "topf";
  };
}
