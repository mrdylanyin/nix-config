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
  name = "nix-vm-arm";
  base-modules = {
    nixos-modules = map mylib.relativeToRoot [
      # common
      # "secrets/nixos.nix"
      "modules/nixos/desktop.nix"
      # host specific
      "hosts/${name}"
    ];
    home-modules = map mylib.relativeToRoot [
      # common
      "home/linux/gui.nix"
      # host specific
      "hosts/${name}/home.nix"
    ];
  };

  modules-hyprland = {
    nixos-modules =
      [
        {
          modules.desktop.wayland.enable = true;
          modules.secrets.desktop.enable = true;
          modules.secrets.impermanence.enable = true;
        }
      ]
      ++ base-modules.nixos-modules;
    home-modules =
      [
        {modules.desktop.hyprland.enable = true;}
      ]
      ++ base-modules.home-modules;
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
    # host with hyprland compositor
    "${name}-hyprland" = mylib.nixosSystem (modules-hyprland // args);
    # host with gnome desktop
    "${name}-gnome" = mylib.nixosSystem (modules-gnome // args);
  };

  # generate iso image for hosts with desktop environment
  packages = {
    "${name}-hyprland" = inputs.self.nixosConfigurations."${name}-hyprland".config.formats.iso;
    "${name}-gnome" = inputs.self.nixosConfigurations."${name}-gnome".config.formats.iso;
  };
}
