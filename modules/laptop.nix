{ pkgs, user, ... }:
let
  monitor-hotplug = pkgs.writeShellApplication {
    name = "monitor-hotplug";
    runtimeInputs = with pkgs; [
      coreutils
      hyprland
      jq
      socat
      brightnessctl
    ];
    text = ''
      internal_monitor() {
        hyprctl -j monitors all \
          | jq -r '.[] | select(.name | startswith("eDP-")) | .name' \
          | head -n 1
      }

      sync_monitors() {
        local internal external_count
        internal="$(internal_monitor)"

        # Do nothing on machines without a built-in laptop display.
        if [[ -z "$internal" ]]; then
          return
        fi

        external_count="$(
          hyprctl -j monitors all \
            | jq --arg internal "$internal" \
              '[.[] | select(.name != $internal)] | length'
        )"

        if (( external_count > 0 )); then
          # Make every connected external output available before turning off
          # the built-in display, so there is never a moment without a screen.
          while IFS= read -r output; do
            if [[ -n "$output" ]]; then
              hyprctl keyword monitor "$output,preferred,auto,1"
            fi
          done < <(
            hyprctl -j monitors all \
              | jq -r --arg internal "$internal" \
                '.[] | select(.name != $internal) | .name'
          )
          hyprctl keyword monitor "$internal,disable"
        else
          hyprctl keyword monitor "$internal,preferred,auto,2"
        fi
      }

      # Apply the correct layout when Hyprland starts with a monitor attached.
      sleep 1
      sync_monitors

      socket="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
      while true; do
        socat -u UNIX-CONNECT:"$socket" - | while IFS= read -r event; do
          case "$event" in
            monitoradded* | monitorremoved*)
              # Give Hyprland a moment to finish updating its monitor list.
              sleep 1
              sync_monitors
              ;;
          esac
        done
        sleep 1
      done
    '';
  };
in
{
  # The laptop needs 32-bit graphics for some visual applications
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  powerManagement.enable = true;
  services.power-profiles-daemon.enable = true;

  # Remove applet connect/disconnect notification
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  home-manager.users.${user} = {
    home.packages = [ monitor-hotplug ];

    # Waybar already provides a system tray, so blueman-applet appears there.
    xdg.configFile."hypr/host.conf".text = ''
      exec-once = ${pkgs.blueman}/bin/blueman-applet
      exec-once = ${monitor-hotplug}/bin/monitor-hotplug

      # Laptop media keys. The repeat flag makes held volume/brightness keys
      # behave naturally; the lock flag keeps them available on the lockscreen.
      bindel = , XF86AudioLowerVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bindel = , XF86AudioRaiseVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+
      bindl = , XF86AudioMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bindl = , XF86AudioMicMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
      bindel = , XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%-
      bindel = , XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%+
    '';
  };
}
