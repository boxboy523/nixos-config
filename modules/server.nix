{ config, lib, pkgs, ... }:

{
  # 뚜껑 닫아도 슬립 안 들어가게
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
  };

  boot.kernelParams = [ "consoleblank=60" ];

  # 서버 포트
  networking.firewall.allowedTCPPorts = [
    80 443    # HTTP/HTTPS
    3000      # Gitea
    3523      # Headscale
    8222      # Vaultwarden
    8096      # Jellyfin
    8888      # qBittorrent
    9090      # Cockpit
  ];

  networking.firewall.allowedUDPPorts = [
    41641      # Tailscale
  ];

  # Headscale (VPN 컨트롤 서버)
  services.headscale = {
    enable = true;
    address = "0.0.0.0";
    port = 3523;
    settings = {
      server_url = "http://june0.kim:3523";
      dns = {
        magic_dns = false;
        nameservers.global = [ "1.1.1.1" "8.8.8.8" ];
      };
    };
  };

  # Gitea
  services.gitea = {
    enable = true;
    appName = "Junyeong's Gitea";
    database.type = "sqlite3";
    settings = {
      server = {
        DOMAIN = "gitea.local";
        HTTP_PORT = 3000;
        ROOT_URL = "http://gitea.local:3000";
      };
      service.DISABLE_REGISTRATION = true;
    };
  };

  # Nextcloud
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud33;
    hostName = "nextcloud.local";
    database.createLocally = true;
    config = {
      dbtype = "sqlite";
      adminpassFile = "/etc/nextcloud-adminpass";
    };
  };

  environment.etc."nextcloud-adminpass".text = "changeme";

  # Vaultwarden
  services.vaultwarden = {
    enable = true;
    dbBackend = "sqlite";
    config = {
      DOMAIN = "http://vaultwarden.local";
      SIGNUPS_ALLOWED = false;
      ROCKET_PORT = 8222;
    };
  };

  # Cockpit
  services.cockpit = {
    enable = true;
    port = 9090;
    openFirewall = true;
    settings.WebService = {
      Origins = lib.mkForce "https://192.168.0.39:9090 https://localhost:9090 https://server:9090";
    };
  };

  # Jellyfin
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  # NVIDIA 트랜스코딩
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  # qBittorrent + Sonarr
  services.qbittorrent = {
    enable = true;
    openFirewall = true;
  };

  services.sonarr = {
    enable = true;
    openFirewall = true;
  };

   environment.systemPackages = with pkgs; [
     eza
     git
     openssl
  ];

  # 미디어 디렉토리
  systemd.tmpfiles.rules = [
    "d /media/anime 0775 jellyfin jellyfin -"
    "d /media/downloads 0775 qbittorrent qbittorrent -"
  ];
}
