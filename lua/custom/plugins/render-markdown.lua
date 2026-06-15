return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons', -- icon provider (already installed)
  },
  ft = { 'markdown', 'gitcommit' },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    file_types = { 'markdown', 'gitcommit' },
  },
}
