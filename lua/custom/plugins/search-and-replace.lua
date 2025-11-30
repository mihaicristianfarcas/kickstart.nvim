return {
  {
    'mihaicristianfarcas/nvim-search-and-replace',
    cmd = 'SearchAndReplaceOpen',
    keys = {
      { '<leader>sar', '<cmd>SearchAndReplaceOpen<cr>', desc = '[S]earch [A]nd [R]eplace' },
    },
    opts = {
      -- Optional configuration
      rg_binary = 'rg',
      literal = true,
      smart_case = true,
    },
  },
}
