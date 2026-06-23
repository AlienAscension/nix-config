{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  # Neovim config files (LazyVim-based, migrated from dotfiles)
  xdg.configFile."nvim/init.lua".source = ./nvim/init.lua;
  xdg.configFile."nvim/lua/config/lazy.lua".source = ./nvim/lua/config/lazy.lua;
  xdg.configFile."nvim/lua/config/options.lua".source = ./nvim/lua/config/options.lua;
  xdg.configFile."nvim/lua/config/keymaps.lua".source = ./nvim/lua/config/keymaps.lua;
  xdg.configFile."nvim/lua/config/autocmds.lua".source = ./nvim/lua/config/autocmds.lua;
  xdg.configFile."nvim/lua/plugins/example.lua".source = ./nvim/lua/plugins/example.lua;

  # Tree-sitter CLI
  home.packages = [ pkgs.tree-sitter ];
}