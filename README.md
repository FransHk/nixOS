# NixOS desktop and laptop configuration

This is deliberately a small, two-host setup. `home/` is shared: Bash aliases,
Hyprland, Waybar, Hyprlock, Starship, Zed, and the small desktop package set.
`hosts/` contains machine-only configuration.

## Before the first rebuild

1. Copy this directory to `~/nix-config` on the installed NixOS system (or keep
   it where it is and use that path in the commands below).
2. On each machine, replace its placeholder hardware file with the one made by
   the NixOS installer:

   ```bash
   cp /etc/nixos/hardware-configuration.nix ~/nix-config/hosts/desktop/
   # On the laptop, use hosts/laptop instead.
   ```

3. Set the desktop machine's actual hostname in
   `hosts/desktop/configuration.nix` if you do not want it named `desktop`.

⚠️
The NixOS installer normally provides a full `/etc/nixos/configuration.nix` too.
Merge its boot-loader and any hardware-specific options into the relevant host
configuration! For example: the boot.initrd.luks will need to be added here and is intentionally not guessed.


## Rebuild

```bash
sudo nixos-rebuild switch --flake ~/nix-config#desktop
# or
sudo nixos-rebuild switch --flake ~/nix-config#laptop
```

The first command creates `flake.lock`; commit it if you put this directory in
Git. Update inputs later with `nix flake update` from the configuration root.

## Laptop scope

Only `hosts/laptop/configuration.nix` enables power management, power profiles,
Bluetooth and Blueman. Brightness key bindings and `brightnessctl` are left as
explicit commented lines in `home/fransh.nix` and `home/hyprland.conf`, ready
to enable once the laptop is migrated.
