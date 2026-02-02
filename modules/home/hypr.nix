{ lib, config, pkgs, inputs, ... }:

{
  options = {
    my.hyprland.configPackage = lib.mkOption {
      type = lib.types.path;
      description = "Hyprland Configuration Path";
    };
  };
  config = {
    home.packages = with pkgs; [
      waybar
      rofi
      hyprpolkitagent
      wl-clipboard
      grim
      slurp
    ];
  
    xdg.configFile = {
      "hypr".source = config.my.hyprland.configPackage;
      "waybar".source = inputs.waybar-conf;
      "rofi".source = inputs.rofi-conf;
    };
  };
}
