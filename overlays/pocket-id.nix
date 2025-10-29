self: super: {
  pocket-id = super.pocket-id.overrideAttrs (
    final: old: {
      version = "1.14.2";

      src = super.fetchFromGitHub {
        owner = "pocket-id";
        repo = "pocket-id";
        tag = "v${final.version}";
        hash = "sha256-0x80oykzMTEsuGUBtXXdKgWJld8mrDPUssYpAznqKnc=";
      };

      vendorHash = "sha256-CmhPURPNwcpmD9shLrQPVKFGBirEMjq0Z4lmgMCpxS8=";

      frontend = old.frontend.overrideAttrs {
        inherit (final) version src;

        pnpmDeps = super.pnpm_10.fetchDeps {
          inherit (final) pname version src;

          fetcherVersion = 1;
          hash = "sha256-/e1zBHdy3exqbMvlv0Jth7vpJd7DDnWXGfMV+Cdr56I=";
        };
      };
    }
  );
}
