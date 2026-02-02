{ config, pkgs, inputs, ... }:
let
  desktopHyprConfig = pkgs.runCommand "desktop-hypr-config" { } ''
    mkdir -p $out

    cp -r ${inputs.hypr-conf}/* $out/
    chmod -R +w $out
      
    cp $out/monitors/desktop.conf $out/monitor.conf
    rm -rf $out/monitors
  '';
in
{
  imports = [ ../modules/home/default.nix ../modules/home/hypr.nix ];
  
  my.hyprland.configPackage = desktopHyprConfig;

  home.file = {
    "downloads".source = config.lib.file.mkOutOfStoreSymlink "/storage/downloads";
    "documents".source = config.lib.file.mkOutOfStoreSymlink "/storage/documents";
    "develop".source = config.lib.file.mkOutOfStoreSymlink "/storage/develop";
    "games".source = config.lib.file.mkOutOfStoreSymlink "/storage/games";
    "conf".source = config.lib.file.mkOutOfStoreSymlink "/storage/conf";
    "music".source     = config.lib.file.mkOutOfStoreSymlink "/storage/music";
    "pictures".source  = config.lib.file.mkOutOfStoreSymlink "/storage/pictures";
    "videos".source    = config.lib.file.mkOutOfStoreSymlink "/storage/videos";
    "desktop".source     = config.lib.file.mkOutOfStoreSymlink "/storage/desktop";
    "public".source  = config.lib.file.mkOutOfStoreSymlink "/storage/public";
    "templates".source    = config.lib.file.mkOutOfStoreSymlink "/storage/templates";
    ".cache".source = config.lib.file.mkOutOfStoreSymlink "/storage/cache";
    ".local/share".source = config.lib.file.mkOutOfStoreSymlink "/storage/local/share";
  };

  xdg = {
    enable = true;
    cacheHome = "/storage/cache";
    dataHome  = "/storage/local/share";
    stateHome = "/storage/local/state";
  };
}
