{ pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    settings = {
      theme = "Catppuccin Frappe";
      window-decoration = false;
      mouse-hide-while-typing = true;
      confirm-close-surface = false;
    };
  };
}