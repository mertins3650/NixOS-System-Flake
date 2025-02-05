{ config, pkgs, lib, ... }:

let
    nixrebuildScript = import ./scripts/nixrebuild.nix { pkgs = pkgs; };
in

{
    home.username = "simonm";
    home.homeDirectory = "/home/simonm";
    home.stateVersion = "24.11"; # Please read the comment before changing.
    
    home.packages = [
        nixrebuildScript,
        pkgs.tmux
        pkgs.zsh
        pkgs.oh-my-zsh       
        pkgs.zoxide
        pkgs.libnotify
        pkgs.swaynotificationcenter
    ];

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

    programs.zsh = {
        enable = true;
        shellAliases = {
            ls = "eza -1 --group-directories-first --icons";
            cd = "z";
            nixupdate = "sudo nixos-rebuild switch --flake";
        };
        oh-my-zsh = {
            enable = true;
            theme = "robbyrussell";
        };
        history.size = 10000;
        history.ignoreAllDups = true;
        history.path = "$HOME/.zsh_history";
    };

    programs.tmux = {
        enable = true;
        extraConfig = ''
            set -g default-terminal "tmux-256color"
            set -s escape-time 0

            unbind C-b
            set-option -g prefix C-a
            bind-key C-a send-prefix
            set -g status-style 'bg=#333333 fg=#5eacd3'

            bind r source-file ~/.tmux.conf
            set -g base-index 1

            bind -r ^ last-window
            bind -r k select-pane -U
            bind -r j select-pane -D
            bind -r h select-pane -L
            bind -r l select-pane -R

            bind-key -r f run-shell "tmux neww ~/.local/scripts/tmux-sessionizer"
            bind-key -r g run-shell "tmux neww ~/.local/scripts/dev-commit"
        '';
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

    home.file = {};

    home.activation.createSymlink = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        rm -rf ~/.config/nvim
        rm -rf ~/.local/scripts/tmux-sessionizer
        mkdir -p ~/.config/nvim
        mkdir -p ~/.local/scripts
        ln -s /home/simonm/NixOS-config/nixos/dotfiles/nvim/* ~/.config/nvim/
        ln -s /home/simonm/NixOS-config/nixos/dotfiles/scripts/tmux-sessionizer ~/.local/scripts/tmux-sessionizer
    '';

    xdg.configFile = {
        fuzzel = {
            source = lib.file.mkOutOfStoreSymlink
                "${config.home.homeDirectory}/NixOS-config/nixos/dotfiles/fuzzel";
            recursive = true;
        };
        hypr = {
            source = lib.file.mkOutOfStoreSymlink
                "${config.home.homeDirectory}/NixOS-config/nixos/dotfiles/hypr";
            recursive = true;
        };
    };

    home.sessionVariables = {
        EDITOR = "nvim";
    };

    programs.home-manager.enable = true;
}

