{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./dark-mode.nix
  ];
  
  home = {
    username = "junyeong";
    homeDirectory = "/home/junyeong";
    stateVersion = "25.11";
    
    packages = with pkgs; [
      fastfetch
      ripgrep
      fd
      eza
      pokeget-rs
      firefoxpwa
      jq
      expect
      btop
      qbittorrent
      nix-index
      python3
      gsettings-desktop-schemas
      glib
      gtk3
      nodejs
    ];

    sessionVariables = {
      BROWSER = "firefox";
      TERMINAL = "kitty";
      XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
      EDITOR = lib.mkForce "emacs -nw";
      VISUAL = lib.mkForce "emacs -nw";
      PWA_GEMINI = "01KG1NTG96PVAT4P7XY55NKG9P";
      PWA_YOUTUBE = "01KG1NV1QGX9SS56GDV23E1AM1";
      PWA_NAMUWIKI = "01KG1NVB8CCCXA8NFWYBERKK1J";
      EMACSDIR = "$HOME/.config/emacs";
      XCURSOR_THEME = "Adwaita";
      XCURSOR_SIZE = 24;
      MOZ_ENABLE_WAYLAND = "1";
      GTK_USE_PORTAL = "1";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      XDG_DATA_DIRS = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}:$XDG_DATA_DIRS";
    };

    sessionPath = [
      "$HOME/bin"
      "$HOME/.local/bin"
      "$HOME/.cargo/bin"
    ];

    pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
    };

    shellAliases = {
       nun = "nix profile remove";
       nup = "nix profile upgrade --all";
       ns = "nix search nixpkgs";
       nf = "nix-locate --minimal --bin --no-case";
    };
  };
  programs = {
    git = {
      enable = true;
      settings.user = {
        name = "Junyeong Kim";
        email = "rlawnsdud523@gmail.com";
      };
      
      settings = {
        init.defaultBranch = "master";
      };
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true; # 문법 하이라이팅
      
      shellAliases = {
        update = "sudo nixos-rebuild switch --flake /storage/conf/nixos-config";
        et = "emacsclient -t";
        ls = "eza";
      };
      initContent = builtins.readFile ../../res/.zshrc;
      dotDir = "${config.xdg.configHome}/zsh";
    };

    kitty = {
      enable = true;

      font = {
        name = "monospace";
        size = 14;
      };
    };

    starship = {
      enable = true;
      enableZshIntegration = false;
    };
  };

  programs.emacs = {
      enable = true;
      package = pkgs.emacs-pgtk;
  };

  xdg.configFile."emacs" = {
    source = inputs.emacs-conf;
    recursive = true;
  };
  
  services.emacs = {
    enable = true;
    defaultEditor = false;
  };
  
  programs.firefox = {
    enable = true;
    nativeMessagingHosts = [ pkgs.firefoxpwa ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    download = "${config.home.homeDirectory}/downloads";
    documents = "${config.home.homeDirectory}/documents";
    music     = "${config.home.homeDirectory}/music";
    pictures  = "${config.home.homeDirectory}/pictures";
    videos    = "${config.home.homeDirectory}/videos";
    desktop   = "${config.home.homeDirectory}/desktop";
    publicShare = "${config.home.homeDirectory}/public";
    templates = "${config.home.homeDirectory}/templates";
  };
  
  home.file = {
    ".config/kime/config.yaml".source = ../../res/kime_config.yaml;
    ".config/nixpkgs".source = ../../res/nixpkgs;
  };
}
