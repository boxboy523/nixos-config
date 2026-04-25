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


  fileSystems = {
    "/storage" = {
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
    "/home/junyeong/develop" = {
      device = "/storage/develop";
      fsType = "none";
      options = [ "bind" ];
    };
    "/home/junyeong/downloads" = {
      device = "/storage/downloads";
      fsType = "none";
      options = [ "bind" ];
    };
    "/home/junyeong/games" = {
      device = "/storage/games";
      fsType = "none";
      options = [ "bind" ];
    };
    "/home/junyeong/conf" = {
      device = "/storage/conf";
      fsType = "none";
      options = [ "bind" ];
    };
    "/home/junyeong/.cache" = {
      device = "/storage/cache";
      fsType = "none";
      options = [ "bind" ];
    };
    "/home/junyeong/.local/share" = {
      device = "/storage/local/share";
      fsType = "none";
      options = [ "bind" ];
    };
    "/home/junyeong/documents" = {
      device = "/storage/documents";
      fsType = "none";
      options = [ "bind" ];
    };
    "/home/junyeong/study" = {
      device = "/storage/study";
      fsType = "none";
      options = [ "bind" ];
    };
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

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "start-game" ''
      trap "systemctl --user stop sunshine" EXIT
      (sleep 3 && systemctl --user start sunshine) &
      exec ${pkgs.gamescope}/bin/gamescope \
        -W 3840 -H 2160 -r 60 \
        --backend wayland \
        -f \
        --cursor-scale-height 2 \
        -- \
        ${pkgs.steam}/bin/steam -tenfoot -gamepadui
    '')
  ];

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

  services.sunshine = {
    enable = true;
    autoStart = false;
    openFirewall = true;
    capSysAdmin = true;
    applications.env = {
      LD_LIBRARY_PATH= "/run/opengl-driver/lib:/run/opengl-driver-32/lib:$LD_LIBRARY_PATH";
    };
      package = pkgs.sunshine.override {
      cudaSupport = true;
      cudaPackages = pkgs.cudaPackages;
    };
  };

  swapDevices = [ {
    device = "/var/lib/swapfile";
    size = 65536; # 32GB (단위: MiB)
  } ];
  hardware.uinput.enable = true;

  users.users.junyeong.extraGroups = [ "input" "video" "render" ];
}
