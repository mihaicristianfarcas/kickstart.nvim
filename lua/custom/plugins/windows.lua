return {
  {
    'anuvyklack/windows.nvim',
    dependencies = {
      'anuvyklack/middleclass',
      'anuvyklack/animation.nvim',
    },
    config = function()
      require('windows').setup {
        autowidth = {
          enable = false,
        },
        ignore = {
          filetype = { 'NvimTree', 'neo-tree', 'undotree', 'gundo', 'diff' },
          buftype = { 'nofile', 'quickfix', 'terminal' },
        },
      }

      -- Optional: keymaps
      vim.api.nvim_set_keymap('n', '<C-w>z', '<Cmd>WindowsMaximize<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<C-w>=', '<Cmd>WindowsEqualize<CR>', { noremap = true, silent = true })
    end,
  },
}
