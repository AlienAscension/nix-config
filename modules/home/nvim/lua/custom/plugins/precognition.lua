-- Motion hints: shows where `w`, `e`, `f`, `gg` ... would land as virtual text.
vim.pack.add { 'https://github.com/tris203/precognition.nvim' }
require('precognition').setup { startVisible = true }

vim.keymap.set('n', '<leader>tp', function() require('precognition').toggle() end, {
  desc = '[T]oggle [p]recognition hints',
})
