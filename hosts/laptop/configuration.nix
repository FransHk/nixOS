{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/gaming.nix
  ];

  networking.hostName = "laptop";

  # Laptop-only infrastructure. This stays out of the desktop host.
  powerManagement.enable = true;
  services.power-profiles-daemon.enable = true;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."luks-a770e119-ba0a-4fdb-9942-994ec9fb96a8".device = "/dev/disk/by-uuid/a770e119-ba0a-4fdb-9942-994ec9fb96a8";
}
