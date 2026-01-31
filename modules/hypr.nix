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
    "hypr".source = pkgs.runCommand "hypr-vm-config" {} ''
    mkdir -p $out
    cp -r ${inputs.hypr-conf}/* $out/

    chmod -R +w $out
    '';
    "waybar".source = inputs.waybar-conf;
    "rofi".source = inputs.rofi-conf;
  };
}
