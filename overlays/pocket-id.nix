self: super: {
  pocket-id = super.pocket-id.overrideAttrs (
    final: old: {
      version = "1.13.1";

      src = super.fetchFromGitHub {
        owner = "pocket-id";
        repo = "pocket-id";
        tag = "v${final.version}";
        hash = "sha256-ayMPyc90bnkIhYfBQ8SgcKayjUQSyrcp5SOLGHTKQwE=";
      };

      vendorHash = "sha256-+HF1zAWA6Ak7uJqWCcTXrttTy1sPA8bN+/No95eqFTU=";

      frontend = old.frontend.overrideAttrs {
        inherit (final) version src;

        pnpmDeps = super.pnpm_10.fetchDeps {
          inherit (final) pname version src;

          fetcherVersion = 1;
          hash = "sha256-IVrp5qWYMgud9ryLidrUowWWBHZ2lMrJp0cfPPHpXls=";
        };
      };
    }
  );
}
