self: super: {
  pocket-id = super.pocket-id.overrideAttrs (
    final: old: {
      version = "1.14.1";

      src = super.fetchFromGitHub {
        owner = "pocket-id";
        repo = "pocket-id";
        tag = "v${final.version}";
        hash = super.lib.fakeHash;
      };

      vendorHash = super.lib.fakeHash;

      frontend = old.frontend.overrideAttrs {
        inherit (final) version src;

        pnpmDeps = super.pnpm_10.fetchDeps {
          inherit (final) pname version src;

          fetcherVersion = 1;
          hash = super.lib.fakeHash;
        };
      };
    }
  );
}
