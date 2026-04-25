{ config, pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
  };
  #:hardware.nvidia-container-toolkit.enable = true;
  users.users.junyeong.extraGroups = [ "docker" ];

  environment.systemPackages = with pkgs; [
    docker-compose
    ctop
  ];
}
