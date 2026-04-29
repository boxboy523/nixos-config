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
    gfxmodeEfi = "2880x1800";
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;
  systemd.user.services.blueman-applet = {
    serviceConfig.ExecStart = lib.mkForce [ "" "${pkgs.blueman}/bin/blueman-applet" ];
  };
  services.libinput.enable = true;
  services.libinput.touchpad = {
    naturalScrolling = true;
    tapping = true;
  };

  environment.systemPackages = with pkgs; [
    libinput
  ];

  networking.hostName = "laptop"; # Define your hostname.

}
