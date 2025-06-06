{
  description = "Zac's NixOS system config with proper CUDA + unfree setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    system = "x86_64-linux";

    # Here's the fixed pkgs with license acceptance baked in
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        android_sdk.accept_license = true;
      };
    };
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        {nixpkgs.pkgs = pkgs;}
        ./configuration.nix
      ];
    };
  };
}
