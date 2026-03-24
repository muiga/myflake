{ self, inputs, ... }:
{
  flake.nixosModules.niri =
    { pkgs, ... }:
    {
      programs.niri = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
      };
    };

  perSystem =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    {
      packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs; # THIS PART IS VERY IMPORTAINT, I FORGOT IT IN THE VIDEO!!!
        # settings = {
        #   spawn-at-startup = [
        #     { command = [ (lib.getExe self'.packages.myNoctalia) ]; }
        #   ];
        #   xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
        #   input.keyboard.xkb.layout = "us,ua";
        #   layout.gaps = 5;
        #   binds = {
        #     "Mod+Return".spawn-sh = lib.getExe pkgs.kitty;
        #     "Mod+Q".close-window = null;
        #     "Mod+S".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";
        #   };
        # };

        settings = {
          xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
          

          prefer-no-csd = true;

          input = {
            keyboard = {
              repeat-rate = 35;
              repeat-delay = 200;
              xkb = { };
              numlock = true;
            };

            touchpad = {
              tap = true;
              dwt = true;
              # dwtp = false;
              # drag = false;
              # drag-lock = false;
              # natural-scroll = false;
              # accel-speed = 0.2;
              # accel-profile = "flat";
              # scroll-method = "two-finger";
              # disabled-on-external-mouse = false;
            };

            mouse = {
              # off = true;
              # natural-scroll = false;
              # accel-speed = 0.2;
              # accel-profile = "flat";
              # scroll-method = "no-scroll";
            };

            trackpoint = {
              # off = true;
              # natural-scroll = false;
              # accel-speed = 0.2;
              # accel-profile = "flat";
              # scroll-method = "on-button-down";
              # scroll-button = 273;
              # scroll-button-lock = false;
              # middle-emulation = false;
            };

            focus-follows-mouse = true;
            # max-scroll-amount = "0%";
          };

          outputs."eDP-1" = {
            mode = "1920x1080@60.01";
            scale = 1;
            transform = "normal";
            position = {
              x = 0;
              y = 0;
            };
          };

          workspaces = [
            "top"
            "main"
          ];

          layout = {
            gaps = 5;
            center-focused-column = "never";
            preset-column-widths = [
              { proportion = 0.5; }
              { proportion = 0.66667; }
              { proportion = 1.0; }
            ];

            default-column-width = {
              proportion = 1.0;
            };

            focus-ring = {
              off = true;
              width = 1;
              active-color = "#cba6f7";
              inactive-color = "#505050";
            };

            border = {
              width = 2;
              active-color = "#cba6f7";
              inactive-color = "#505050";
              urgent-color = "#9b0000";
            };

            struts = {
              top = -2;
              bottom = -4;
              left = -2;
              right = -2;
            };
          };

          spawn-at-startup = [
            { command = [ (lib.getExe self'.packages.myNoctalia) ]; }

            [
              "systemctl"
              "--user"
              "start"
              "hypridle.service"
            ]
          ];

          hotkey-overlay = {
            # skip-at-startup = true;
          };

          switch-events = {
            lid-close = {
              spawn = "hyprlock";
            };
          };

          screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

          animations = {
            # off = true;
            # slowdown = 3.0;
          };

          window-rules = [
            {
              matches = [
                { app-id = "^org\\.wezfurlong\\.wezterm$"; }
              ];
              default-column-width = { };
            }
            {
              matches = [
                { app-id = "xdg.desktop-portal"; }
              ];
              open-floating = true;
              open-focused = true;
              min-height = 700;
              min-width = 750;
            }
            {
              matches = [
                { app-id = "zen-twilight"; }
                { title = "^Zen Twilight"; }
              ];
              open-maximized = true;
              open-on-workspace = "top";
            }
            {
              matches = [
                { app-id = "Code"; }
              ];
              open-maximized = true;
            }
            {
              matches = [
                { app-id = "org.kde.haruna"; }
              ];
              open-maximized = true;
            }
            {
              matches = [
                { app-id = "firefox$"; }
                { title = "^Picture-in-Picture$"; }
              ];
              open-floating = true;
            }
            {
              geometry-corner-radius = 8;
              clip-to-geometry = true;
            }
          ];

          layer-rules = [
            {
              matches = [
                { namespace = "^noctalia-overview*"; }
              ];
              place-within-backdrop = true;
            }
          ];

          overview = { };

          binds = {
            "Mod+Shift+Slash" = {
              show-hotkey-overlay = true;
            };
            "Mod+T" = {
              hotkey-overlay-title = "Open a Terminal: konsole";
              action = {
                spawn = "konsole";
              };
            };
            "Mod+Space" = {
              hotkey-overlay-title = "Run an Application: Rofi";
              action = {
                spawn-sh = "rofi -show drun";
              };
            };
            "Mod+Alt+L" = {
              hotkey-overlay-title = "Lock the Screen: hyprlock";
              action = {
                spawn = "hyprlock";
              };
            };
            "Mod+Alt+S" = {
              allow-when-locked = true;
              hotkey-overlay-title = null;
              action = {
                spawn-sh = "pkill orca || exec orca";
              };
            };

            "XF86AudioRaiseVolume" = {
              allow-when-locked = true;
              action = {
                spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+";
              };
            };
            "XF86AudioLowerVolume" = {
              allow-when-locked = true;
              action = {
                spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
              };
            };
            "XF86AudioMute" = {
              allow-when-locked = true;
              action = {
                spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
              };
            };
            "XF86AudioMicMute" = {
              allow-when-locked = true;
              action = {
                spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
              };
            };

            "XF86MonBrightnessUp" = {
              allow-when-locked = true;
              action = {
                spawn = [
                  "brightnessctl"
                  "--class=backlight"
                  "set"
                  "+10%"
                ];
              };
            };
            "XF86MonBrightnessDown" = {
              allow-when-locked = true;
              action = {
                spawn = [
                  "brightnessctl"
                  "--class=backlight"
                  "set"
                  "10%-"
                ];
              };
            };

            "XF86AudioPlay" = {
              allow-when-locked = true;
              action = {
                spawn = "playerctl play-pause";
              };
            };
            "XF86AudioStop" = {
              allow-when-locked = true;
              action = {
                spawn = "playerctl stop";
              };
            };
            "XF86AudioNext" = {
              allow-when-locked = true;
              action = {
                spawn = "playerctl next";
              };
            };
            "XF86AudioPrev" = {
              allow-when-locked = true;
              action = {
                spawn = "playerctl previous";
              };
            };

            "Mod+O" = {
              repeat = false;
              action = {
                toggle-overview = true;
              };
            };
            "Mod+Q" = {
              repeat = false;
              action = {
                close-window = true;
              };
            };

            "Mod+Left" = {
              focus-column-left = true;
            };
            "Mod+Down" = {
              focus-window-down = true;
            };
            "Mod+Up" = {
              focus-window-up = true;
            };
            "Mod+Right" = {
              focus-column-right = true;
            };
            "Mod+H" = {
              focus-column-left = true;
            };
            "Mod+J" = {
              focus-window-down = true;
            };
            "Mod+K" = {
              focus-window-up = true;
            };
            "Mod+L" = {
              focus-column-right = true;
            };

            "Mod+Ctrl+Left" = {
              move-column-left = true;
            };
            "Mod+Ctrl+Down" = {
              move-window-down = true;
            };
            "Mod+Ctrl+Up" = {
              move-window-up = true;
            };
            "Mod+Ctrl+Right" = {
              move-column-right = true;
            };
            "Mod+Ctrl+H" = {
              move-column-left = true;
            };
            "Mod+Ctrl+J" = {
              move-window-down = true;
            };
            "Mod+Ctrl+K" = {
              move-window-up = true;
            };
            "Mod+Ctrl+L" = {
              move-column-right = true;
            };

            "Mod+Home" = {
              focus-column-first = true;
            };
            "Mod+End" = {
              focus-column-last = true;
            };
            "Mod+Ctrl+Home" = {
              move-column-to-first = true;
            };
            "Mod+Ctrl+End" = {
              move-column-to-last = true;
            };

            "Mod+Shift+Left" = {
              focus-monitor-left = true;
            };
            "Mod+Shift+Down" = {
              focus-monitor-down = true;
            };
            "Mod+Shift+Up" = {
              focus-monitor-up = true;
            };
            "Mod+Shift+Right" = {
              focus-monitor-right = true;
            };
            "Mod+Shift+H" = {
              focus-monitor-left = true;
            };
            "Mod+Shift+J" = {
              focus-monitor-down = true;
            };
            "Mod+Shift+K" = {
              focus-monitor-up = true;
            };
            "Mod+Shift+L" = {
              focus-monitor-right = true;
            };

            "Mod+Shift+Ctrl+Left" = {
              move-column-to-monitor-left = true;
            };
            "Mod+Shift+Ctrl+Down" = {
              move-column-to-monitor-down = true;
            };
            "Mod+Shift+Ctrl+Up" = {
              move-column-to-monitor-up = true;
            };
            "Mod+Shift+Ctrl+Right" = {
              move-column-to-monitor-right = true;
            };
            "Mod+Shift+Ctrl+H" = {
              move-column-to-monitor-left = true;
            };
            "Mod+Shift+Ctrl+J" = {
              move-column-to-monitor-down = true;
            };
            "Mod+Shift+Ctrl+K" = {
              move-column-to-monitor-up = true;
            };
            "Mod+Shift+Ctrl+L" = {
              move-column-to-monitor-right = true;
            };

            "Mod+Page_Down" = {
              focus-workspace-down = true;
            };
            "Mod+Page_Up" = {
              focus-workspace-up = true;
            };
            "Mod+U" = {
              focus-workspace-down = true;
            };
            "Mod+I" = {
              focus-workspace-up = true;
            };
            "Mod+Ctrl+Page_Down" = {
              move-column-to-workspace-down = true;
            };
            "Mod+Ctrl+Page_Up" = {
              move-column-to-workspace-up = true;
            };
            "Mod+Ctrl+U" = {
              move-column-to-workspace-down = true;
            };
            "Mod+Ctrl+I" = {
              move-column-to-workspace-up = true;
            };

            "Mod+Shift+Page_Down" = {
              move-workspace-down = true;
            };
            "Mod+Shift+Page_Up" = {
              move-workspace-up = true;
            };
            "Mod+Shift+U" = {
              move-workspace-down = true;
            };
            "Mod+Shift+I" = {
              move-workspace-up = true;
            };

            "Mod+WheelScrollDown" = {
              cooldown-ms = 150;
              action = {
                focus-workspace-down = true;
              };
            };
            "Mod+WheelScrollUp" = {
              cooldown-ms = 150;
              action = {
                focus-workspace-up = true;
              };
            };
            "Mod+Ctrl+WheelScrollDown" = {
              cooldown-ms = 150;
              action = {
                move-column-to-workspace-down = true;
              };
            };
            "Mod+Ctrl+WheelScrollUp" = {
              cooldown-ms = 150;
              action = {
                move-column-to-workspace-up = true;
              };
            };

            "Mod+WheelScrollRight" = {
              focus-column-right = true;
            };
            "Mod+WheelScrollLeft" = {
              focus-column-left = true;
            };
            "Mod+Ctrl+WheelScrollRight" = {
              move-column-right = true;
            };
            "Mod+Ctrl+WheelScrollLeft" = {
              move-column-left = true;
            };

            "Mod+Shift+WheelScrollDown" = {
              focus-column-right = true;
            };
            "Mod+Shift+WheelScrollUp" = {
              focus-column-left = true;
            };
            "Mod+Ctrl+Shift+WheelScrollDown" = {
              move-column-right = true;
            };
            "Mod+Ctrl+Shift+WheelScrollUp" = {
              move-column-left = true;
            };

            "Mod+1" = {
              focus-workspace = 1;
            };
            "Mod+2" = {
              focus-workspace = 2;
            };
            "Mod+3" = {
              focus-workspace = 3;
            };
            "Mod+4" = {
              focus-workspace = 4;
            };
            "Mod+5" = {
              focus-workspace = 5;
            };
            "Mod+6" = {
              focus-workspace = 6;
            };
            "Mod+7" = {
              focus-workspace = 7;
            };
            "Mod+8" = {
              focus-workspace = 8;
            };
            "Mod+9" = {
              focus-workspace = 9;
            };
            "Mod+Shift+1" = {
              move-column-to-workspace = 1;
            };
            "Mod+Shift+2" = {
              move-column-to-workspace = 2;
            };
            "Mod+Shift+3" = {
              move-column-to-workspace = 3;
            };
            "Mod+Shift+4" = {
              move-column-to-workspace = 4;
            };
            "Mod+Shift+5" = {
              move-column-to-workspace = 5;
            };
            "Mod+Shift+6" = {
              move-column-to-workspace = 6;
            };
            "Mod+Shift+7" = {
              move-column-to-workspace = 7;
            };
            "Mod+Shift+8" = {
              move-column-to-workspace = 8;
            };
            "Mod+Shift+9" = {
              move-column-to-workspace = 9;
            };

            "Mod+BracketLeft" = {
              consume-or-expel-window-left = true;
            };
            "Mod+BracketRight" = {
              consume-or-expel-window-right = true;
            };

            "Mod+Comma" = {
              consume-window-into-column = true;
            };
            "Mod+Period" = {
              expel-window-from-column = true;
            };

            "Mod+R" = {
              switch-preset-column-width = true;
            };
            "Mod+Shift+R" = {
              switch-preset-window-height = true;
            };
            "Mod+Ctrl+R" = {
              reset-window-height = true;
            };
            "Mod+F" = {
              maximize-column = true;
            };
            "Mod+Shift+F" = {
              fullscreen-window = true;
            };

            "Mod+Ctrl+F" = {
              expand-column-to-available-width = true;
            };

            "Mod+C" = {
              center-column = true;
            };
            "Mod+Ctrl+C" = {
              center-visible-columns = true;
            };

            "Mod+Minus" = {
              set-column-width = "-10%";
            };
            "Mod+Equal" = {
              set-column-width = "+10%";
            };

            "Mod+Shift+Minus" = {
              set-window-height = "-10%";
            };
            "Mod+Shift+Equal" = {
              set-window-height = "+10%";
            };

            "Mod+V" = {
              toggle-window-floating = true;
            };
            "Mod+Shift+V" = {
              switch-focus-between-floating-and-tiling = true;
            };

            "Mod+W" = {
              toggle-column-tabbed-display = true;
            };

            "Print" = {
              screenshot = true;
            };
            "Ctrl+Print" = {
              screenshot-screen = true;
            };
            "Alt+Print" = {
              screenshot-window = true;
            };

            "Mod+Escape" = {
              allow-inhibiting = false;
              action = {
                toggle-keyboard-shortcuts-inhibit = true;
              };
            };

            "Mod+Shift+E" = {
              quit = true;
            };
            "Ctrl+Alt+Delete" = {
              quit = true;
            };

            "Mod+Shift+P" = {
              power-off-monitors = true;
            };

            # Custom binds
            "Mod+Alt+V" = {
              hotkey-overlay-title = "Toggle Warp";
              action = {
                spawn = [
                  "sh"
                  "-c"
                  "warp-cli status | grep -q 'Connected' && warp-cli disconnect || warp-cli connect"
                ];
              };
            };
            "Mod+B" = {
              hotkey-overlay-title = "Show Bluetooth Panel";
              action = {
                spawn = [
                  "noctalia-shell"
                  "ipc"
                  "call"
                  "bluetooth"
                  "togglePanel"
                ];
              };
            };
            "Mod+S" = {
              hotkey-overlay-title = "Show launcher";
              action = {
                spawn-sh = "noctalia-shell ipc call launcher toggle";
              };
            };
          };
        };
      };
    };
}
