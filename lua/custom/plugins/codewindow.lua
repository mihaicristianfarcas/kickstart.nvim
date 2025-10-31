return {
  {
    'gorbit99/codewindow.nvim',
    config = function()
      local codewindow = require 'codewindow'
      codewindow.setup {
        minimap_width = 10,
      }
      vim.keymap.set('n', '<leader>mm', codewindow.toggle_minimap, { desc = 'Toggle minimap' })
      vim.keymap.set('n', '<leader>mf', codewindow.toggle_focus, { desc = 'Toggle minimap' })
    end,
  },
}
