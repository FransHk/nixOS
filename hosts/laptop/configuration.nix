{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/laptop.nix
  ];

  # Networking: prefer ethernet over
  # Wi-Fi when both are connected.
  networking.hostName = "laptop";
  networking.networkmanager = {
    enable = true;
    settings = {
      connection-ethernet = {
        match-device = "type:ethernet";
        "ipv4.route-metric" = 100;
        "ipv6.route-metric" = 100;
        "connection.autoconnect-priority" = 100;
      };
      connection-wifi = {
        match-device = "type:wifi";
        "ipv4.route-metric" = 600;
        "ipv6.route-metric" = 600;
        "connection.autoconnect-priority" = 10;
      };
    };
  };
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."luks-a770e119-ba0a-4fdb-9942-994ec9fb96a8".device = "/dev/disk/by-uuid/a770e119-ba0a-4fdb-9942-994ec9fb96a8";

  # Install the tailscale package.
  environment.systemPackages = with pkgs; [
    tailscale
  ];
  # Initialize nixOs service (runs the background tailscale
  # daemon.)
  services.tailscale.enable = true;


}
