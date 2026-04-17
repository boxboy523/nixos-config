 { config, confRoot, ... }:
 {
   imports = [ ../modules/home/default.nix ../modules/home/hypr.nix ];

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
    PWA_CLAUDE = "01KNPJ5HWFKAPNKYRECHHDT8CD";
  };

  xdg = {
    enable = true;
    cacheHome = "/storage/cache";
    dataHome  = "/storage/local/share";
    stateHome = "/storage/local/state";
    configFile."hypr-monitor.conf".source = config.lib.file.mkOutOfStoreSymlink "${confRoot}/hypr/monitors/desktop.conf";
  };
}
