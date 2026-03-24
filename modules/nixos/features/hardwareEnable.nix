{ ... }:
{
  flake.nixosModules.hardwareEnable =
    { pkgs, ... }:
    {
      hardware = {
        bluetooth.enable = true;
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
    };
}
