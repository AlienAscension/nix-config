-- Local keymaps, loaded from the "SECTION 11: LOCAL ADDITIONS" block at the
-- bottom of init.lua. Keep your own tweaks in this directory: it is ours, not
-- upstream kickstart.nvim, so re-syncing init.lua never touches it.

-- Copy & paste with the shortcuts you already have in your fingers.
--
-- Neovim's `+` register is the system clipboard. Kickstart already sets
-- `vim.o.clipboard = 'unnamedplus'`, so plain `y`/`p` work on the clipboard
-- too; the mappings below are the editor-style muscle memory.
--
--   visual mode   <C-c>   copy the selected lines to the system clipboard
--   visual mode   <C-v>   paste over the selection (replaces it)
--   insert mode   <C-v>   paste at the cursor
--   `:` / `/`     <C-v>   paste into the command line
--
-- Normal mode deliberately keeps <C-v> as block-wise visual mode (block select
-- stays reachable from every other mode via <C-q>); paste there with `p`, which
-- is already clipboard-aware.
vim.keymap.set({ 'x', 'v' }, '<C-c>', '"+y', { desc = 'Copy selection to the system clipboard' })

vim.keymap.set({ 'x', 'v' }, '<C-v>', '"+p', { desc = 'Paste over the selection from the system clipboard' })
vim.keymap.set({ 'i', 'c' }, '<C-v>', '<C-r>+', { desc = 'Paste from the system clipboard' })
