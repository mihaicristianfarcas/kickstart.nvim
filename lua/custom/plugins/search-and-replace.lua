return {
  {
    'mihaicristianfarcas/nvim-search-and-replace',
    cmd = 'SearchAndReplaceOpen',
    keys = {
      { '<leader>sar', '<cmd>SearchAndReplaceOpen<cr>', desc = '[S]earch [A]nd [R]eplace' },
      { '<leader>sav', '<cmd>SearchAndReplaceVisual<cr>', desc = '[S]earch [A]nd replace [V]isual' },
    },
    opts = {
      -- Optional configuration
      rg_binary = 'rg',
      literal = true,
      smart_case = false,
    },
  },
}
