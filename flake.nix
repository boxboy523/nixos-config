{
  description = "Junyeong's NixOS Flake Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hypr-conf = {
      #url = "github:boxboy523/hypr";
      url = "path:/home/junyeong/config/hypr";
      flake = false;
    };

    waybar-conf = {
      url = "github:boxboy523/waybar";
      flake = false;
    };

    rofi-conf = {
      url = "github:boxboy523/rofi";
      flake = false;
    };

    emacs-conf = {
      url = "path:/home/junyeong/config/emacs-config";
      flake = false;
    };

    monoplex = {
      url = "https://github.com/y-kim/monoplex/releases/download/v0.0.2/MonoplexKR-v0.0.2.zip";
      flake = false;
    };

    nanum-neo = {
      url = "github:moonspam/NanumSquareNeo";
      flake = false;
    };

    hahmlet = {
      url = "https://github.com/hyper-type/hahmlet";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      "nixos-main" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.junyeong = import ./home.nix;
          }
        ];
      };
    };
  };
}
