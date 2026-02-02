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
    gfxmodeEfi = "3840x2160";
  };

  boot.kernelParams = [
    "video=DP-4:3840x2160@144"
    "video=HDMI-A-2:1920x1080@60"
  ];

  networking.hostName = "desktop"; # Define your hostname.

  programs.fuse.userAllowOther = true;
  
  fileSystems."/storage" = {
    fsType = "fuse.mergerfs";
    device = "/mnt/ssd1:/mnt/ssd2";
    options = [
      "cache.files=off"
      "func.getattr=newest"
      "dropcacheonclose=false"
      "minfreespace=10G"
      "category.create=pfrd"
      "fsname=storage_merged"
      "x-systemd.automount"
    ];
  };
  
  services.openssh.enable = true;
  systemd.tmpfiles.rules = [
    "d /storage 0755 junyeong users -"
  ];

  services.udev.extraRules = ''
  SUBSYSTEM=="drm", KERNEL=="card[0-9]*", KERNELS=="0000:01:00.0", SYMLINK+="card-nvidia"
  SUBSYSTEM=="drm", KERNEL=="card[0-9]*", KERNELS=="0000:11:00.0", SYMLINK+="card-igpu"
  '';

  environment.sessionVariables = {
    AQ_DRM_DEVICES = "/dev/card-igpu:/dev/card-nvidia";
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    powerManagement.enable = false;
    nvidiaSettings = true;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      amdgpuBusId = "PCI:11:00:0";
      nvidiaBusId = "PCI:01:00:0";
    };
    
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}


