{ config, pkgs, ... }:
{
  home.username = "fransh";
  home.homeDirectory = "/home/fransh";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    waybar hyprlock hyprpaper wofi kitty firefox thunar zed-editor
    grim slurp swappy pavucontrol networkmanagerapplet upower
    nerd-fonts.jetbrains-mono git wl-clipboard codex gh
  ];
  fonts.fontconfig.enable = true;

  programs.home-manager.enable = true;
  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      ls = "ls --color=auto";
      grep = "grep --color=auto";
      l = "ls --color=auto -CF";
      ga = "git add";
      gc = "git commit -m";
      gp = "git push";
      hyconf = "vim /etc/nixos/home/hyprland/hyprland.conf";
      rebuild = "sudo nixos-rebuild switch --flake ~/Documents/nixOS#desktop"
      hyreload = "hyprctl reload";
      open = "thunar";
      sh = "TERM=xterm-256color ssh";
      untar = "tar -xvf";
      totar = "tar -cvf";
    };
  };


  programs.neovim = {
    enable = true;

    extraConfig = ''
      set clipboard=unnamedplus
    '';
  };




  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = builtins.fromTOML (builtins.readFile ./starship/starship.toml);
  };

  # The configurations sources here are symlinked to the ./config
  # dir so that they are available to e.g. hyprland, etc.
  xdg.configFile = {
    "hypr/hyprlock.conf".source = ./hyprland/hyprlock.conf;
    "hypr/hyprpaper.conf".text = ''
      wallpaper {
        monitor = *
        path = /etc/nixos/assets/archy.jpg
      }
      splash = false
    '';
    "hypr/wallpapers/archy.jpg".source = ../assets/archy.jpg;
    "waybar/config.jsonc".source = ./waybar/config.jsonc;
    "waybar/style.css".source = ./waybar/style.css;
    "kitty/kitty.conf".source = ./kitty/kitty.conf;
    "zed/settings.json".source = ./zed/settings.json;
    "zed/keymap.json".source = ./zed/keymap.json;
    "hypr/hyprland.conf".source = ./hyprland/hyprland.conf;
  };

  # Laptop-only Home Manager additions, to add when desired:
  # home.packages = with pkgs; [ brightnessctl ];
  # Bind XF86MonBrightness{Up,Down} in home/hyprland/hyprland.conf.
}
