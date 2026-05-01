{ ... }:
{
  flake.nixosModules.hardwareEnable =
    { pkgs, ... }:
    {
      hardware = {
        bluetooth = {
          enable = true;
          powerOnBoot = true;
          settings = {
            General = {
              Enable = "Source,Sink,Media,Socket";
              FastConnectable = true;
              MultiProfile = "multiple";
              Experimental = true;
            };
          };
        };
        graphics = {
          enable = true;
          extraPackages = with pkgs; [
            libva-vdpau-driver
            libvdpau-va-gl
          ];
          enable32Bit = true;
        };
      };

      services.udev.packages = with pkgs; [
        libusb1
        brightnessctl
      ];
      services.fprintd.enable = true;
      services.fwupd.enable = true;
      services.tuned.enable = true;
      services.upower.enable = true;
      # services.blueman.enable = true;
      #
      systemd.user.services.mpris-proxy = {
        description = "Mpris proxy";
        after = [
          "network.target"
          "sound.target"
        ];
        wantedBy = [ "default.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
        };
      };
    };
}
