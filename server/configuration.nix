{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true;
    gfxmodeEfi = "2560x1600";
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;
  services.libinput.enable = true;
  services.libinput.touchpad = {
    naturalScrolling = true;
    tapping = true;
  };

  environment.systemPackages = with pkgs; [
    libinput
  ];

  networking.hostName = "server"; # Define your hostname.

}
