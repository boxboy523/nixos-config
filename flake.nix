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
          confRoot = "/home/junyeong/conf";
        };
        modules = [
          ./laptop/configuration.nix
          ./modules/core.nix
          ./modules/game.nix
          ./modules/docker.nix
          ./modules/desktop.nix
          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-cpu-amd-pstate
          nixos-hardware.nixosModules.common-gpu-amd
          nixos-hardware.nixosModules.common-pc-laptop-ssd
          nixos-hardware.nixosModules.lenovo-ideapad-slim-5
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
      "server" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          confRoot = "/home/junyeong/conf";
        };
        modules = [
          ./server/configuration.nix
          ./modules/core.nix
          ./modules/docker.nix
          nixos-hardware.nixosModules.lenovo-ideapad-16ach6
          {
            nixpkgs.config.allowUnfree = true;
          }
        ];
      };
    };
  };
}
