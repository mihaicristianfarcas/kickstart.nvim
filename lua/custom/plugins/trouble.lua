return {
  'folke/trouble.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  cmd = { 'Trouble' },
  opts = {
    focus = true,
  },
  keys = {
    { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
    { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },
    { '<leader>xs', '<cmd>Trouble symbols toggle<cr>', desc = 'Symbols (Trouble)' },
    { '<leader>xr', '<cmd>Trouble lsp_references toggle<cr>', desc = 'LSP References (Trouble)' },
    { '<leader>xl', '<cmd>Trouble loclist toggle<cr>', desc = 'Location List (Trouble)' },
    { '<leader>xq', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix List (Trouble)' },
    {
      '[d',
      function()
        require('trouble').prev { skip_groups = true, jump = true }
      end,
      desc = 'Previous diagnostic',
    },
    {
      ']d',
      function()
        require('trouble').next { skip_groups = true, jump = true }
      end,
      desc = 'Next diagnostic',
    },
  },
}
