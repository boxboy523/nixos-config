{
  description = "Junyeong's NixOS Flake Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    monoplex = {
      url = "https://github.com/y-kim/monoplex/releases/download/v0.0.2/MonoplexKR-v0.0.2.zip";
      flake = false;
    };

    nanum-neo = {
      url = "github:moonspam/NanumSquareNeo";
      flake = false;
    };

    hahmlet = {
      url = "github:hyper-type/hahmlet";
      flake = false;
    };

    gemini-cli-src = {
      url = "github:google-gemini/gemini-cli/v0.32.1";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, ... }@inputs: {
    nixosConfigurations = {
      "desktop" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          confRoot = "/storage/conf";
        };
        modules = [
          ./desktop/configuration.nix
          ./modules/core.nix
          ./modules/game.nix
          ./modules/docker.nix
          {
            nixpkgs.config.allowUnfree = true;
          }
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit inputs;
              confRoot = "/storage/conf";
            };
            home-manager.users.junyeong = import ./desktop/home.nix;
          }
        ];
      };
      "laptop" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          confRoot = "/storage/conf";
        };
        modules = [
          ./laptop/configuration.nix
          ./modules/core.nix
          ./modules/game.nix
          ./modules/docker.nix
          nixos-hardware.nixosModules.lenovo-ideapad-16ach6
          {
            nixpkgs.config.allowUnfree = true;
          }
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit inputs;
              confRoot = "/home/junyeong/conf";
            };
            home-manager.users.junyeong = import ./laptop/home.nix;
          }
        ];
      };
    };
  };
}
