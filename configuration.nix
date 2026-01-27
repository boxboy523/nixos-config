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

    extraEntries = ''
      menuentry "Windows 11" {
        insmod part_gpt
        insmod fat
        insmod search_fs_uuid
        insmod chain
        
        # 윈도우 부팅 파일(bootmgfw.efi)을 찾아서 실행해라
        search --file --no-floppy --set=root /EFI/Microsoft/Boot/bootmgfw.efi
        chainloader /EFI/Microsoft/Boot/bootmgfw.efi
      }
    '';
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
  ];

  fileSystems."/home/junyeong" = {
    fsType = "mergerfs";
    device = "/home/junyeong_local:/ssd_2";

    options = [
      "defaults"
      "allow_other"
      "minifreespace=10G"
      "category.create=ff"
      "fsname=mergerfs_home"
      "x-systemd.requires=/home"
      "x-systemd.requires=/ssd_2"
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


