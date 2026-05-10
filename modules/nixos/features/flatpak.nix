{ inputs, ... }:
{
  flake.nixosModules.flatpak =
    { ... }:
    {
      # import any other modules from here
      imports = [
        inputs.nix-flatpak.nixosModules.nix-flatpak
      ];

      services.flatpak.remotes = [
        {
          name = "flathub";
          location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
        }
      ];

      services.flatpak.packages = [
        {
          appId = "com.stremio.Stremio";
          origin = "flathub";
        }
        {
          appId = "com.markopejic.downloader";
          origin = "flathub";
        }
        {
          appId = "org.gtk.Gtk3theme.adw-gtk3";
          origin = "flathub";
        }
        {
          appId = "org.gtk.Gtk3theme.adw-gtk3-dark";
          origin = "flathub";
        }
        {
          appId = "io.github.cosmic_utils.cosmic-ext-applet-clipboard-manager";
          origin = "cosmic";
        }
      ];

      services.flatpak.uninstallUnmanaged = true;

      services.flatpak.update.onActivation = true;

      services.flatpak.update.auto = {
        enable = true;
        onCalendar = "weekly";
      };
    };
}
