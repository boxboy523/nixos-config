{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-vm"; # Define your hostname.

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

  fonts.packages = with pkgs; [
    nerd-fonts.terminess-ttf
    noto-fonts
    noto-fonts-cjk-sans
    font-awesome
  ];

  console = {
    enable = true;
    font = "Lat2-Terminus16";
    packages = with pkgs; [ nerd-fonts.terminess-ttf ];
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

  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    curl
  ];

  environment.sessionVariables = {
    WLR_NO_HARDWAR_CURSORS = "1";
  };
  
  services.openssh.enable = true;

  programs = {
    zsh.enable = true;
    hyprland.enable = true;
  };
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11"; 
}


