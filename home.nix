{ config, pkgs, ... }:

{
  imports = [
      ./hypr.nix
  ];
  
  home = {
    username = "junyeong";
    homeDirectory = "/home/junyeong";
    stateVersion = "25.11";
    
    packages = with pkgs; [
      htop
      fastfetch
      ripgrep
      fd
      eza
      pokeget-rs
    ];

    sessionVariables = {
      BROWSER = "firefox";
      TERMINAL = "kitty";
    };

    sessionPath = [
      "$HOME/bin"
      "$HOME/.local/bin"
      "$HOME/.cargo/bin"
    ];
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

      initContent = builtins.readFile ./res/zshrc;
    };

    kitty.enable = true;
    
  };

  home.file.".config/kime/config.yaml".source = ./res/kime_config.yaml;

  programs.emacs = {
      enable = true;
      package = pkgs.emacs;
  };
    
  services.emacs = {
    enable = true;
    defaultEditor = true;
  };
}
