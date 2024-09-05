{
  pkgs,
  config,
  lib,
  anyrun,
  ...
}: {
  config = lib.mkIf config.modules.desktop.gnome.enable {
    # GNOME 相关的 home-manager 配置
    dconf.settings = {
      # 示例：设置默认主题
      "org/gnome/desktop/interface" = {
        gtk-theme = "Adwaita-dark";
      };
    };

    home.packages = with pkgs; [
      # 添加您想要的 GNOME 应用或工具
      gnome.gnome-tweaks
      gnome.dconf-editor
    ];
  };
}
