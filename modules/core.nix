{ config, lib, pkgs, inputs, ... }:

{
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Seoul";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "ko_KR.UTF-8/UTF-8"
    ];
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

  console = {
    enable = true;
    keyMap = "us";
  };

  users.users.junyeong = {
    isNormalUser = true;
    description = "Junyeong Kim";
    extraGroups = [ "networkmanager" "wheel" ];
    initialPassword = "password";
    shell = pkgs.zsh;
  };

  users.mutableUsers = true;

  nix.settings.trusted-users = [ "root" "junyeong" ];

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    cmake
    gnumake
    gcc
    libtool
    pkg-config
    atool
    zip
    unzip
    gnutar
    unrar
    p7zip
    git
    tailscale
  ];

  services.openssh.enable = true;

  programs.zsh.enable = true;


  # Tailscale
  services.tailscale.enable = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nix.settings.auto-optimise-store = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11";
}
