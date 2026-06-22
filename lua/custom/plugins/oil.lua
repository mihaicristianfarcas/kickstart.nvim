-- oil.nvim: browse and edit the filesystem as if it were a normal buffer.
-- `-` opens the parent directory; then edit the listing (rename/delete/create
-- lines) and `:w` to apply the changes to disk.
return {
  {
    'stevearc/oil.nvim',
    -- Lazy loading is not recommended because it is very tricky to make it work
    -- correctly in all situations, so we load it eagerly.
    lazy = false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    keys = {
      { '-', '<cmd>Oil<CR>', desc = 'Open parent directory (Oil)' },
    },
  },
}
