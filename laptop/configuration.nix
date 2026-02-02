{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the sXystemd-boot EFI boot loader.
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true;
    gfxmodeEfi = "2560x1600";
  };

  networking.hostName = "laptop"; # Define your hostname.
}


