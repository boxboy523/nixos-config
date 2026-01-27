{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    lutris
    protonup-qt
    mangohud
    discord
    pavucontrol
    xorg.xrandr
  ];
}
