-- Blocks repeated hjkl / arrow presses and hints at the motion to use instead.
-- Its hint popups need nui.nvim, so that goes in first.
vim.pack.add { 'https://github.com/MunifTanjim/nui.nvim' }
vim.pack.add { 'https://github.com/m4xshen/hardtime.nvim' }
require('hardtime').setup {}
