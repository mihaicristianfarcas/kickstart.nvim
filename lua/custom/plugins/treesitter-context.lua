-- treesitter-context.nvim: pins the enclosing scope (function/class/etc.) to the
-- top of the window as you scroll, so you always see where you are.
--   <leader>tc  toggle the context on/off
--   [x          jump up to the context line
return {
  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    event = 'VeryLazy',
    opts = {
      enable = true,
      max_lines = 3,
      min_window_height = 0,
      line_numbers = true,
      multiline_threshold = 20,
      trim_scope = 'outer',
      mode = 'cursor',
    },
    keys = {
      {
        '<leader>tc',
        function()
          require('treesitter-context').toggle()
        end,
        desc = '[T]oggle treesitter [C]ontext',
      },
      {
        '[x',
        function()
          require('treesitter-context').go_to_context(vim.v.count1)
        end,
        desc = 'Go to context',
      },
    },
  },
}
