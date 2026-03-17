{ lib, config, pkgs, inputs, confRoot, ... }:

{
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
      "hypr".source = config.lib.file.mkOutOfStoreSymlink "${confRoot}/hypr";
      "waybar".source = config.lib.file.mkOutOfStoreSymlink "${confRoot}/waybar";
      "rofi".source = config.lib.file.mkOutOfStoreSymlink "${confRoot}/rofi";
    };
  };
}
