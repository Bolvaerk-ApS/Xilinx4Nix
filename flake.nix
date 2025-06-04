{
  description = "Flake for installing Xilinx Vivado";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/25.05";
  };
  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
  in {
    packages = {
      x86_64-linux = {
        vivado = pkgs.callPackage ./pkgs/vivado.nix {};
      };
    };
    devShells.x86_64-linux.default = pkgs.callPackage ./pkgs/vivado.nix {};
  };
}
