return {
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    event = 'VeryLazy',
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup {
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['af'] = { query = '@function.outer', desc = 'Select around function' },
              ['if'] = { query = '@function.inner', desc = 'Select inside function' },
              ['ac'] = { query = '@class.outer', desc = 'Select around class' },
              ['ic'] = { query = '@class.inner', desc = 'Select inside class' },
              ['aa'] = { query = '@parameter.outer', desc = 'Select around argument' },
              ['ia'] = { query = '@parameter.inner', desc = 'Select inside argument' },
              ['ai'] = { query = '@conditional.outer', desc = 'Select around conditional' },
              ['ii'] = { query = '@conditional.inner', desc = 'Select inside conditional' },
              ['al'] = { query = '@loop.outer', desc = 'Select around loop' },
              ['il'] = { query = '@loop.inner', desc = 'Select inside loop' },
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              [']f'] = { query = '@function.outer', desc = 'Next function start' },
              [']c'] = { query = '@class.outer', desc = 'Next class start' },
              [']a'] = { query = '@parameter.inner', desc = 'Next argument' },
            },
            goto_next_end = {
              [']F'] = { query = '@function.outer', desc = 'Next function end' },
              [']C'] = { query = '@class.outer', desc = 'Next class end' },
            },
            goto_previous_start = {
              ['[f'] = { query = '@function.outer', desc = 'Previous function start' },
              ['[c'] = { query = '@class.outer', desc = 'Previous class start' },
              ['[a'] = { query = '@parameter.inner', desc = 'Previous argument' },
            },
            goto_previous_end = {
              ['[F'] = { query = '@function.outer', desc = 'Previous function end' },
              ['[C'] = { query = '@class.outer', desc = 'Previous class end' },
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ['<leader>sa'] = { query = '@parameter.inner', desc = '[S]wap with next [A]rgument' },
            },
            swap_previous = {
              ['<leader>sA'] = { query = '@parameter.inner', desc = '[S]wap with previous [A]rgument' },
            },
          },
        },
      }
    end,
  },

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
