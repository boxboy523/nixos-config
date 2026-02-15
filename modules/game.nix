{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  programs.gamemode.enable = true;
  environment.systemPackages = with pkgs; [
    lutris (
      lutris.override {
        extraPkgs = pkgs: [
          pkgs.libnghttp2
          pkgs.winetricks
        ];
      }
    )
    protonup-qt
    mangohud
    discord
    pavucontrol
    xorg.xrandr
    wineWow64Packages.staging
    winetricks
    vulkan-loader
    vulkan-tools
    dxvk
  ];
  environment.sessionVariables = {
    VK_ICD_FILENAMES = "${config.hardware.nvidia.package}/share/vulkan/icd.d/nvidia_icd.x86_64.json:${config.hardware.nvidia.package.lib32}/share/vulkan/icd.d/nvidia_icd.i686.json";
  };
}
