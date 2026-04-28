{ config, lib, pkgs, inputs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 22000 8384 ];
  networking.firewall.allowedUDPPorts = [ 22000 8384 ];

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5
      fcitx5-hangul
      qt6Packages.fcitx5-configtool
      libsForQt5.fcitx5-qt
    ];
  };

  fonts = {
    packages = with pkgs; [
      nerd-fonts.terminess-ttf
      nerd-fonts.d2coding
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-monochrome-emoji
      nanum
      nanum-gothic-coding
      vista-fonts
      liberation_ttf
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
    font = "ter-v32n";
    packages = with pkgs; [ terminus_font ];
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
        ids = [ "*" ];
        settings = {
          main = {
            capslock = "overload(control, esc)";
            tab = "overload(meta, tab)";
          };
        };
      };
    };
  };

  users.users.junyeong.extraGroups = [ "uinput" ];

  environment.systemPackages = with pkgs; [
    keyd
    qemu
    libvterm
  ];

  environment.sessionVariables = {
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };

  programs.ydotool.enable = true;

  programs.hyprland.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "gtk";
  };
}
