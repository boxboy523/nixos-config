{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    waybar
    rofi
    hyprpolkitagent
  ];
  
  xdg.configFile = {
    "hypr".source = pkgs.runCommand "hypr-vm-config" {} ''
    mkdir -p $out
    cp -r ${inputs.hypr-conf}/* $out/

    cp $out/hyprland-vm.conf $out/hyprland.conf
    '';
    "waybar".source = inputs.waybar-conf;
    "rofi".source = inputs.rofi-conf;
  };
}
