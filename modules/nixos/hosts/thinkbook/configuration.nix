{ self, ... }:
{

  flake.nixosModules.thinkbookConfiguration =
    { pkgs, ... }:
    {
      # import any other modules from here
      imports = [
        self.nixosModules.thinkbookHardware
        self.nixosModules.disko
        self.nixosModules.boot
        self.nixosModules.packages
        self.nixosModules.networking
        self.nixosModules.audio
        self.nixosModules.fonts
        self.nixosModules.nix
        self.nixosModules.printing
        self.nixosModules.storage
        self.nixosModules.virtualisation
        self.nixosModules.niri
        self.nixosModules.zsh
        self.nixosModules.backlight
      ];

      networking.hostName = "thinkbook"; # Define your hostname.

      # Set your time zone.
      time.timeZone = "Africa/Nairobi";

      # Select internationalisation properties.
      i18n.defaultLocale = "en_US.UTF-8";

      # Enable the X11 windowing system.
      # services.xserver.enable = true;

      # Enable the GNOME Desktop Environment.
      services.displayManager.gdm.enable = true;
      #services.displayManager.gdm.settings = {
      #security.AllowRoot = false;
      #};
      services.desktopManager.gnome.enable = true;

      # Configure keymap in X11
      services.xserver.xkb = {
        layout = "us";
        variant = "";
      };

      # Enable touchpad support (enabled default in most desktopManager).
      # services.xserver.libinput.enable = true;

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users.muiga = {
        isNormalUser = true;
        description = "muiga";
        extraGroups = [
          "networkmanager"
          "wheel"
          "docker"
          "tailscale"
        ];
        shell = pkgs.zsh;
      };

      # Install firefox.
      programs.firefox.enable = true;
      services.cloudflare-warp = {
        enable = true;
      };
      security.pki.certificateFiles = [
        ./certs/rootCA.pem
      ];

    };

}
