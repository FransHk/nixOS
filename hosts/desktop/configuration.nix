{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/base.nix
  ];

  networking.hostName = "nixf";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
