{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule (finalAttrs: {
  pname = "topf";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "postfinance";
    repo = "topf";
    rev = "v${finalAttrs.version}";
    hash = "sha256-q9Gr1UuFOxptui6ZOhE0qTMXXVAkLjkAX0n9rzlpaOU=";
  };

  vendorHash = "sha256-TyrlEJjh3SwBaGowM+f096GM2WGfDcxW+RWqspAB7rU=";

  subPackages = [ "cmd/topf" ];

  meta = {
  description = "Talos Orchestrator by PostFinance";
  homepage = "https://github.com/postfinance/topf";
  license = lib.licenses.mit;
  mainProgram = "topf";
  maintainers = with lib.maintainers; [ AlienAscension ];
};
}
