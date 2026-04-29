{ ... }:
{
  flake.nixosModules.backlight =
    { pkgs, ... }:

    let
      inactivityTimeout = 30;

      backlightScript = pkgs.writeShellScript "kbd-backlight-watch" ''
        #!/usr/bin/env bash
        set -euo pipefail

        TIMEOUT=${toString inactivityTimeout}
        ACTIVE=1
        LAST_ACTIVITY=$(date +%s)

        turn_on() {
          if [ "$ACTIVE" -eq 0 ]; then
            ACTIVE=1
            ${pkgs.brightnessctl}/bin/brightnessctl -d platform::kbd_backlight set 50
            echo "Backlight ON"
          fi
        }

        turn_off() {
          if [ "$ACTIVE" -eq 1 ]; then
            ACTIVE=0
            ${pkgs.brightnessctl}/bin/brightnessctl -d platform::kbd_backlight set 0
            echo "Backlight OFF"
          fi
        }

        get_devices() {
          ${pkgs.gawk}/bin/awk '
            /Handlers=/ && (/kbd/ || /mouse/) {
              match($0, /event[0-9]+/, a)
              if (a[0] != "") print "/dev/input/" a[0]
            }
          ' /proc/bus/input/devices
        }

        watchdog() {
          while true; do
            NOW=$(date +%s)
            ELAPSED=$(( NOW - LAST_ACTIVITY ))
            if [ "$ELAPSED" -ge "$TIMEOUT" ]; then
              turn_off
            fi
            sleep 5
          done
        }

        watchdog &
        WATCHDOG_PID=$!
        trap "kill $WATCHDOG_PID 2>/dev/null; exit 0" EXIT INT TERM

        DEVICES=$(get_devices)
        if [ -z "$DEVICES" ]; then
          echo "No input devices found, exiting"
          exit 1
        fi

        echo "Monitoring devices: $DEVICES"

        ${pkgs.evtest}/bin/evtest $DEVICES 2>/dev/null | while IFS= read -r line; do
          if echo "$line" | grep -q "EV_KEY\|EV_REL\|EV_ABS"; then
            LAST_ACTIVITY=$(date +%s)
            turn_on
          fi
        done
      '';

    in
    {
      environment.systemPackages = [
        pkgs.brightnessctl
        pkgs.evtest
        pkgs.gawk
      ];

      # evtest needs /dev/input access
      services.udev.extraRules = ''
        KERNEL=="event*", SUBSYSTEM=="input", GROUP="input", MODE="0660"
      '';

      systemd.services.kbd-backlight-watch = {
        description = "Turn off keyboard backlight on inactivity";
        wantedBy = [ "multi-user.target" ]; # starts at boot
        after = [ "systemd-udevd.service" ]; # wait for input devices

        serviceConfig = {
          ExecStart = "${backlightScript}";
          Restart = "always";
          RestartSec = "5s";
          # Run as root so it can access /dev/input and brightnessctl
          User = "root";
          # Logging
          StandardOutput = "journal";
          StandardError = "journal";
          SyslogIdentifier = "kbd-backlight";
        };
      };
    };
}
