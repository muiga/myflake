{ inputs, ... }:
{
  flake.nixosModules.flatpak =
    { ... }:
    {
      # import any other modules from here
      imports = [
        inputs.nix-flatpak.nixosModules.nix-flatpak
      ];

      services.flatpak.enable = true;

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

      ];

      services.flatpak.uninstallUnmanaged = true;

      services.flatpak.update.onActivation = true;

      services.flatpak.update.auto = {
        enable = true;
        onCalendar = "weekly";
      };
    };
}
