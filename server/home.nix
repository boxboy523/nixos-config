{ config, pkgs, inputs, confRoot, ... }:
{
  imports = [ ../modules/home/default.nix ../modules/home/hypr.nix ];
  home.sessionVariables = {
    PWA_GEMINI = "01KHP43TQ5WM8Z21H4YT2WPPJ4";
    PWA_YOUTUBE = "01KHP46TV04EJSANPR2EV14Z0C";
    PWA_NAMUWIKI = "01KHP45YZ0D4G462F3VCA5FBRQ";
    PWA_CLAUDE = "01KNR4K7GWZC64YXPHYZ6MXGSG";
  };

  home.packages = with pkgs; [
    # 1. 하드웨어 제어 유틸 (Hyprland 단축키 연동용)
    brightnessctl  # 화면 밝기 조절 (F5, F6 키 매핑용)
    pamixer        # 볼륨 조절 (F1, F2 키 매핑용)
    playerctl      # 미디어 키 (재생/일시정지) 제어

    # 2. 시스템 트레이 도구 (Waybar 우측 상단용)
    networkmanagerapplet  # 와이파이 아이콘 (nm-applet)
    blueman               # 블루투스 관리자 (blueman-applet)
    pasystray             # 볼륨 조절 트레이 (선택사항)

    # 3. 전력 모니터링
    powertop       # 배터리 누가 먹나 감시하는 툴 (CS 전공자 필수템)
  ];

  xdg.configFile."hypr-monitor.conf".source = config.lib.file.mkOutOfStoreSymlink "${confRoot}/hypr/monitors/laptop.conf";
}
