{username, ...} @ args:
#############################################################
#
#  Fern - MacBook Pro 2022 13-inch M2 16G, mainly for business.
#
#############################################################
let
  hostname = "fern";
in {
  networking.hostName = hostname;
  networking.computerName = hostname;
  system.defaults.smb.NetBIOSName = hostname;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."${username}" = {
    home = "/Users/${username}";
    description = username;

    # set user's default shell back to zsh
    #    `chsh -s /bin/zsh`
    # DO NOT change the system's default shell to nushell! it will break some apps!
    # It's better to change only starship/alacritty/vscode's shell to nushell!
  };
}
