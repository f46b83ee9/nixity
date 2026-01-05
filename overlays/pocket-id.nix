self: super: {
  pocket-id = super.pocket-id.overrideAttrs (
    final: old: {
      version = "2.1.0";

      src = super.fetchFromGitHub {
        owner = "pocket-id";
        repo = "pocket-id";
        tag = "v${final.version}";
        hash = "sha256-tBjo5evQVRG0oembk1VfAfM3M/FJ4zPWV/9vgAWH9Kc=";
      };

      vendorHash = "sha256-hMhOG/2xnI/adjg8CnA0tRBD8/OFDsTloFXC8iwxlV0=";

      frontend = old.frontend.overrideAttrs {
        inherit (final) version src;

        pnpmDeps = super.fetchPnpmDeps {
          inherit (final) pname version src;

          pnpm = super.pnpm_10;
          fetcherVersion = 1;

          hash = "sha256-dIhNxUBt+jxUp5I4cPZ6/PtNSyMTd6xkX6XE2SwD+ok=";         
        };
      };
    }
  );
}
