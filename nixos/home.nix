{ config, pkgs, ... }:

{
  home.username = "simonm";
  home.homeDirectory = "/home/simonm";
  home.stateVersion = "24.11"; # Please read the comment before changing.

  gtk.theme = {
    name = "Adwaita-dark";
    package = pkgs.gnome.gnome-themes-extra;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        };
    };

  qt.enable = true;
  qt.platformTheme.name = "gtk";
  qt.style.name = "adwaita-dark";
  qt.style.package = pkgs.adwaita-qt;

  home.packages = [
  pkgs.zsh
  pkgs.oh-my-zsh       
  pkgs.zoxide
  ];

  programs.zsh = {
    enable = true;
    shellAliases = {
        ls = "eza -1 --group-directories-first --icons";
        cd = "z";
        };
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
        };
    history.size = 10000;
    history.ignoreAllDups = true;
    history.path = "$HOME/.zsh_history";
  };


programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
};

  programs.git = {
    enable = true;
    userName = "Simon Mertins";
    userEmail = "mertins99@gmail.com";
  };

home.file = {
};

xdg.configFile."nvim".source = ./dotfiles/nvim;
xdg.configFile."hypr".source = ./dotfiles/hypr;
xdg.configFile."fuzzel".source = ./dotfiles/fuzzel;


  home.sessionVariables = {
     EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
}
