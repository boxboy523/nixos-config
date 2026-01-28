{ config, pkgs, lib, inputs, ... }:

{
  imports = [
      ./hypr.nix
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
    ];

    sessionVariables = {
      BROWSER = "firefox";
      TERMINAL = "kitty";
      XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
      XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
      XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";
      EDITOR = lib.mkForce "emacs -nw";
      VISUAL = lib.mkForce "emacs -nw";
      PWA_GEMINI = "01KFZJRF039NWZT10FBYKE6J1N";
      PWA_YOUTUBE = "01KFZJS6JPCF3HQ5V1MBM0Y15N";
      PWA_NAMUWIKI = "01KFZJTTYG3XVJBAF5XV63Z0BS";
      EMACSDIR = "$HOME/.config/emacs";
      XCURSOR_THEME = "Adwaita";
      XCURSOR_SIZE = 24;
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

    starship.enable = true;
    
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true; # 문법 하이라이팅
      
      shellAliases = {
        update = "sudo nixos-rebuild switch --flake ~/nixos-config";
        et = "emacsclient -t";
        ls = "eza";
      };

      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "sudo" "docker" ];
      };

      initContent = builtins.readFile ./res/.zshrc;
    };

    kitty = {
      enable = true;

      font = {
        name = "monospace";
        size = 14;
      };
    };
  };

  home.file.".config/kime/config.yaml".source = ./res/kime_config.yaml;

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
}
