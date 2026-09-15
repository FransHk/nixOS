{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/base.nix
  ];

  networking.hostName = "laptop";

  # Laptop-only infrastructure. This stays out of the desktop host.
  powerManagement.enable = true;
  services.power-profiles-daemon.enable = true;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
}
