{
  # NOTE: the args not used in this file CAN NOT be removed!
  # because haumea pass argument lazily,
  # and these arguments are used in the functions like `mylib.nixosSystem`, `mylib.colmenaSystem`, etc.
  inputs,
  lib,
  myvars,
  mylib,
  system,
  genSpecialArgs,
  ...
} @ args: let
  name = "vm";
  base-modules = {
    nixos-modules = map mylib.relativeToRoot [
      # common
      # "secrets/nixos.nix"
      "modules/nixos/desktop.nix"
      # host specific
      "hosts/idols-${name}"
    ];
    home-modules = map mylib.relativeToRoot [
      # common
      "home/linux/gui.nix"
      # host specific
      "hosts/idols-${name}/home.nix"
    ];
  };

  modules-gnome = {
    nixos-modules =
      [
        {
          modules.desktop.gnome.enable = true;
          modules.secrets.desktop.enable = true;
          modules.secrets.impermanence.enable = true;
        }
      ]
      ++ base-modules.nixos-modules;
    home-modules =
      [
        {modules.desktop.gnome.enable = true;}
      ]
      ++ base-modules.home-modules;
  };
in {
  nixosConfigurations = {
    # host with GNOME desktop
    "${name}-gnome" = mylib.nixosSystem (modules-gnome // args);
  };

  # generate iso image for hosts with desktop environment
  packages = {
    "${name}-gnome" = inputs.self.nixosConfigurations."${name}-gnome".config.formats.iso;
  };
}
