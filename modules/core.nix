{ config, lib, pkgs, inputs, ... }:

{
  boot.loader.efi.canTouchEfiVariables = true;

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Seoul";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    
    inputMethod = {
      enable = true;
      type = "kime";
      kime.iconColor = "Black";
    };
    
    extraLocaleSettings = {
      LC_ADDRESS = "ko_KR.UTF-8";
      LC_IDENTIFICATION = "ko_KR.UTF-8";
      LC_MEASUREMENT = "ko_KR.UTF-8";
      LC_MONETARY = "ko_KR.UTF-8";
      LC_NAME = "ko_KR.UTF-8";
      LC_NUMERIC = "ko_KR.UTF-8";
      LC_PAPER = "ko_KR.UTF-8";
      LC_TELEPHONE = "ko_KR.UTF-8";
      LC_TIME = "ko_KR.UTF-8";
    };
  };

  fonts = {
    packages = with pkgs; [
      nerd-fonts.terminess-ttf
      noto-fonts
      noto-fonts-cjk-sans
      font-awesome
      (pkgs.runCommand "monoplex-font" { } ''
        mkdir -p $out/share/fonts/truetype
        find ${inputs.monoplex} -name "*.ttf" -exec cp {} $out/share/fonts/truetype/ \;
      '')
      (pkgs.runCommand "hahmlet-font" { } ''
        mkdir -p $out/share/fonts/opentype
        find ${inputs.hahmlet} -name "*.otf" -exec cp {} $out/share/fonts/opentype/ \;
        find ${inputs.hahmlet} -name "*.ttf" -exec cp {} $out/share/fonts/truetype/ \; || true
      '')
      (pkgs.runCommand "nanum-square-neo" { } ''
        mkdir -p $out/share/fonts/opentype
        find ${inputs.nanum-neo} -name "*.otf" -exec cp {} $out/share/fonts/opentype/ \;
      '')
    ];

    fontconfig = {
      enable = true;
      localConf = builtins.readFile ../res/fonts.conf;
    };
  };

  console = {
    enable = true;
    font = "ter-v32n";
    packages = with pkgs; [ terminus_font ];
    keyMap = "us";
  };

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ]; # 모든 키보드에 적용
        settings = {
          main = {
            # 캡스락: 짧게 치면 ESC, 길게 누르면 Ctrl (Emacs/Vim 국룰 세팅)
            capslock = "overload(control, esc)";
            
            # (선택사항) 만약 탭도 오버로드 하고 싶다면? (탭: 탭, 길게: Ctrl)
            # tab = "overload(control, tab)"; 
          };
        };
      };
    };
  };

  users.users.junyeong = {
    isNormalUser = true;
    description = "Junyeong Kim";
    extraGroups = [ "networkmanager" "wheel"];
    initialPassword = "password";
    shell = pkgs.zsh;
  };

  users.mutableUsers = true;
  
  nix.settings.trusted-users = [ "root" "junyeong" ];
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    pkgs.mergerfs
    cmake
    gnumake
    gcc
    libtool
    pkg-config
    libvterm
  ];
  
  services.openssh.enable = true;

  programs = {
    zsh.enable = true;
    hyprland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "gtk";
  };
  
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nix.settings.auto-optimise-store = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11";
}


