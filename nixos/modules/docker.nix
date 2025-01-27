{ config, pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    docker
    docker-compose
    lazydocker
  ];

  # Enable Docker service
  virtualisation.docker = {
    enable = true;
    daemon = {
      settings = {
        "log-driver" = "json-file";
        "log-opts" = {
          "max-size" = "10m";
          "max-file" = "3";
        };
      };
    };
  };

  # Systemd services for Docker containers
  systemd.services.mysql8 = {
    description = "MySQL 8 Container";
    after = [ "docker.service" ];
    wants = [ "docker.service" ];
    serviceConfig = {
      ExecStart = ''
        ${pkgs.docker}/bin/docker run --name mysql8 \
          -e MYSQL_ROOT_PASSWORD= \
          -e MYSQL_ALLOW_EMPTY_PASSWORD=true \
          -p "127.0.0.1:3306:3306" \
          --restart unless-stopped \
          -d mysql:8.4
      '';
      ExecStop = ''
        ${pkgs.docker}/bin/docker stop mysql8
        ${pkgs.docker}/bin/docker rm mysql8
      '';
      Restart = "always";
    };
    wantedBy = [ "multi-user.target" ];
  };

  systemd.services.postgres16 = {
    description = "Postgres 16 Container";
    after = [ "docker.service" ];
    wants = [ "docker.service" ];
    serviceConfig = {
      ExecStart = ''
        ${pkgs.docker}/bin/docker run --name postgres16 \
          -e POSTGRES_HOST_AUTH_METHOD=trust \
          -p "127.0.0.1:5432:5432" \
          --restart unless-stopped \
          -d postgres:16
      '';
      ExecStop = ''
        ${pkgs.docker}/bin/docker stop postgres16
        ${pkgs.docker}/bin/docker rm postgres16
      '';
      Restart = "always";
    };
    wantedBy = [ "multi-user.target" ];
  };
}

