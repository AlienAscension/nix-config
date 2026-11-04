{ lib, buildGoModule, fetchFromGitHub, go_1_27 }:

(buildGoModule.override { go = go_1_27; }) (finalAttrs: {
  pname = "topf";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "postfinance";
    repo = "topf";
    rev = "v${finalAttrs.version}";
    hash = "sha256-frUyZtpA0iyFwHxlN5SqZ0WFfU4sMalmdkHtulg+B3I=";
  };

  vendorHash = "sha256-VLZLPM1/a1Lf5ggk4pwB/AL+Drrdfmm3f9DYjvpBKcA=";

  subPackages = [ "cmd/topf" ];

  ldflags = [ "-X main.version=v${finalAttrs.version}" ];

  meta = {
    description = "Talos Orchestrator by PostFinance";
    homepage = "https://github.com/postfinance/topf";
    license = lib.licenses.mit;
    mainProgram = "topf";
    maintainers = [ (import ./maintainer-list.nix).AlienAscension ];
  };
})
