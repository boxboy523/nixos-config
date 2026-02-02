{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    waybar
    rofi
    hyprpolkitagent
    wl-clipboard
    grim
    slurp
  ];
  
  xdg.configFile = {
    "hypr".source = inputs.hypr-conf;
    "waybar".source = inputs.waybar-conf;
    "rofi".source = inputs.rofi-conf;
  };
}
