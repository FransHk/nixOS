{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/base.nix # TODO let's combine this configuration and that of base.nix, it is an arbitrary division
    ../../modules/laptop.nix
  ];

  # Install the tailscale and slack packages. These are only used for laptop
  environment.systemPackages = with pkgs; [
    tailscale
    slack
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
  # Run Electron applications such as Slack natively under Wayland.
  environment.sessionVariables.NIXOS_OZONE_WL = "1";




  # Initialize nixOs service (runs the background tailscale
  # daemon.)
  services.tailscale.enable = true;


}
