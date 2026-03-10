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
#    "downloads".source = config.lib.file.mkOutOfStoreSymlink "/storage/downloads";
#    "documents".source = config.lib.file.mkOutOfStoreSymlink "/storage/documents";
#    "develop".source = config.lib.file.mkOutOfStoreSymlink "/storage/develop";
#    "games".source = config.lib.file.mkOutOfStoreSymlink "/storage/games";
#    "conf".source = config.lib.file.mkOutOfStoreSymlink "/storage/conf";
    "music".source     = config.lib.file.mkOutOfStoreSymlink "/storage/music";
    "pictures".source  = config.lib.file.mkOutOfStoreSymlink "/storage/pictures";
    "videos".source    = config.lib.file.mkOutOfStoreSymlink "/storage/videos";
    "desktop".source     = config.lib.file.mkOutOfStoreSymlink "/storage/desktop";
    "public".source  = config.lib.file.mkOutOfStoreSymlink "/storage/public";
    "templates".source    = config.lib.file.mkOutOfStoreSymlink "/storage/templates";
#    ".cache".source = config.lib.file.mkOutOfStoreSymlink "/storage/cache";
#    ".local/share".source = config.lib.file.mkOutOfStoreSymlink "/storage/local/share";
  };

  home.sessionVariables = {
    XDG_CACHE_HOME = "/storage/cache";
    XDG_DATA_HOME  = "/storage/local/share";
    XDG_STATE_HOME = "/storage/local/state";
    PWA_GEMINI = "01KG1NTG96PVAT4P7XY55NKG9P";
    PWA_YOUTUBE = "01KG1NV1QGX9SS56GDV23E1AM1";
    PWA_NAMUWIKI = "01KG1NVB8CCCXA8NFWYBERKK1J";
  };
  xdg = {
    enable = true;
    cacheHome = "/storage/cache";
    dataHome  = "/storage/local/share";
    stateHome = "/storage/local/state";
  };
}
