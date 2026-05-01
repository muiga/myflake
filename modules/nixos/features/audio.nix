{ ... }:
{
  flake.nixosModules.audio =
    { ... }:
    {
      security.rtkit.enable = true;
      services.pulseaudio.enable = false;

      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        audio.enable = true;
        pulse.enable = true;
        jack.enable = true;
        wireplumber.enable = true;
      };

      # Add this WirePlumber drop-in
      environment.etc."wireplumber/bluetooth.lua.d/50-bluez-suspend-on-idle.lua".text = ''
        -- Force suspend idle Bluetooth sinks after 3 seconds
        bluez_monitor.properties = {
          ["node.latency"] = 512,
          ["node.nick"] = "ALSA",
          ["node.description"] = "Bluetooth Audio",
          ["priority.session"] = 1000,
          ["node.pause-on-idle"] = true,  -- Key: allow suspension
          ["session.suspend-timeout-seconds"] = 3, -- Drop idle sink after 3 seconds
        }
      '';
    };
}
