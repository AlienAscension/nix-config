{ pkgs, lib, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    vimdiffAlias = true;

    # Kickstart does its work at runtime: vim.pack clones plugins and build
    # steps compile parts of them. `extraPackages` appends to the wrapper's
    # PATH (the session PATH keeps priority), so nvim finds the toolchain even
    # when it was started from an environment with a minimal PATH.
    #   - kickstart's PackChanged hook runs `make` (telescope-fzf-native, LuaSnip)
    #   - nvim-treesitter shells out to the `tree-sitter` CLI to build parsers,
    #     and that CLI needs a C compiler (`cc`)
    # macOS gets `make` and `clang` from the Xcode command line tools, so
    # nothing is added there. The clipboard needs no package on either platform:
    # the nixpkgs nvim wrapper pulls in wl-clipboard when `waylandSupport` is on
    # (the default on Linux), and macOS uses the built-in pbcopy/pbpaste.
    extraPackages = lib.optionals pkgs.stdenv.isLinux [
      pkgs.gcc
      pkgs.gnumake
    ];
  };

  # Neovim config: a vendored copy of kickstart.nvim, pinned to
  # nvim-lua/kickstart.nvim@8e35dbedb7966e3a95e1f26f9fc1179ab6c68db4
  # (2026-10-03). Kickstart is meant to be owned rather than tracked: to update,
  # copy upstream's init.lua over `nvim/init.lua`, re-add the marked
  # "SECTION 11: LOCAL ADDITIONS" block at the bottom, and leave `nvim/lua/custom`
  # alone — that directory is ours.
  #
  # NOTE: deliberately symlinks for the files/dirs we manage instead of the
  # whole `nvim` directory. `~/.config/nvim` must stay a real, writable
  # directory because vim.pack writes its lockfile (`nvim-pack-lock.json`) next
  # to init.lua, and /nix/store is read-only.
  xdg.configFile."nvim/init.lua".source = ./nvim/init.lua;
  xdg.configFile."nvim/lua/kickstart".source = ./nvim/lua/kickstart;
  xdg.configFile."nvim/lua/custom".source = ./nvim/lua/custom;

  # Tree-sitter CLI — also what nvim-treesitter calls to build parsers.
  home.packages = [ pkgs.tree-sitter ];
}
