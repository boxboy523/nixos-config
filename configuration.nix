{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./game.nix
    ];

  # Use the sXystemd-boot EFI boot loader.
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true;
    gfxmodeEfi = "3840x2160";
  };
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [
    "video=DP-4:3840x2160@144"
    "video=HDMI-A-2:1920x1080@60"
  ];

  networking.hostName = "nixos-main"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Seoul";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    
    inputMethod = {
      enable = true;
      type = "kime";
      kime.iconColor = "Black";
    };
    
    extraLocaleSettings = {
      LC_ADDRESS = "ko_KR.UTF-8";
      LC_IDENTIFICATION = "ko_KR.UTF-8";
      LC_MEASUREMENT = "ko_KR.UTF-8";
      LC_MONETARY = "ko_KR.UTF-8";
      LC_NAME = "ko_KR.UTF-8";
      LC_NUMERIC = "ko_KR.UTF-8";
      LC_PAPER = "ko_KR.UTF-8";
      LC_TELEPHONE = "ko_KR.UTF-8";
      LC_TIME = "ko_KR.UTF-8";
    };
  };

  fonts = {
    packages = with pkgs; [
      nerd-fonts.terminess-ttf
      noto-fonts
      noto-fonts-cjk-sans
      font-awesome
      (pkgs.runCommand "monoplex-font" { } ''
        mkdir -p $out/share/fonts/truetype
        find ${inputs.monoplex} -name "*.ttf" -exec cp {} $out/share/fonts/truetype/ \;
      '')
      (pkgs.runCommand "hahmlet-font" { } ''
        mkdir -p $out/share/fonts/opentype
        find ${inputs.hahmlet} -name "*.otf" -exec cp {} $out/share/fonts/opentype/ \;
        find ${inputs.hahmlet} -name "*.ttf" -exec cp {} $out/share/fonts/truetype/ \; || true
      '')
      (pkgs.runCommand "nanum-square-neo" { } ''
        mkdir -p $out/share/fonts/opentype
        find ${inputs.nanum-neo} -name "*.otf" -exec cp {} $out/share/fonts/opentype/ \;
      '')
    ];

    fontconfig = {
      enable = true;
      localConf = builtins.readFile ./res/fonts.conf;
    };
  };

  console = {
    enable = true;
    font = "ter-v32n";
    packages = with pkgs; [ terminus_font ];
    keyMap = "us";
  };

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.junyeong = {
    isNormalUser = true;
    description = "Junyeong Kim";
    extraGroups = [ "networkmanager" "wheel"];
    initialPassword = "password";
    shell = pkgs.zsh;
  };

  nix.settings.trusted-users = [ "root" "junyeong" ];
  
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    curl
    pkgs.mergerfs
    cmake
    gnumake
    gcc
    libtool
    pkg-config
    libvterm
  ];

  programs.fuse.userAllowOther = true;
  
  fileSystems."/home/junyeong" = {
    fsType = "fuse.mergerfs";
    device = "/mnt/ssd1:/mnt/ssd2";
    options = [
      "cache.files=off"
      "func.getattr=newest"
      "dropcacheonclose=false"
      "minfreespace=10G"
      "category.create=pfrd"
      "fsname=storage_merged"
    ];
  };
  
  services.openssh.enable = true;

  programs = {
    zsh.enable = true;
    hyprland.enable = true;
  };

  services.udev.extraRules = ''
  SUBSYSTEM=="drm", KERNEL=="card[0-9]*", KERNELS=="0000:01:00.0", SYMLINK+="card-nvidia"
  SUBSYSTEM=="drm", KERNEL=="card[0-9]*", KERNELS=="0000:11:00.0", SYMLINK+="card-igpu"
  '';

  environment.sessionVariables = {
    AQ_DRM_DEVICES = "/dev/card-igpu:/dev/card-nvidia";
  };
    
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nix.settings.auto-optimise-store = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11"; 
}


