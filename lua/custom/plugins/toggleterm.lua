return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      require('toggleterm').setup {
        size = function(term)
          if term.direction == 'horizontal' then
            return 20
          elseif term.direction == 'vertical' then
            return vim.o.columns * 0.4
          end
        end,
        direction = 'vertical',
        open_mapping = [[<C-\>]],
        shade_terminals = false,
      }

      -- Toggle terminal in normal, insert, and terminal modes
      local toggle_term = '<cmd>ToggleTerm<CR>'
      vim.keymap.set('n', '<C-\\>', toggle_term, { desc = 'Toggle terminal', silent = true })
      vim.keymap.set('i', '<C-\\>', toggle_term, { desc = 'Toggle terminal', silent = true })
      vim.keymap.set('t', '<C-\\>', toggle_term, { desc = 'Toggle terminal', silent = true })

      local Terminal = require('toggleterm.terminal').Terminal

      -- Custom lazygit terminal
      local lazygit = Terminal:new {
        cmd = 'lazygit',
        dir = vim.fn.getcwd(),
        direction = 'float',
        float_opts = {
          border = 'single',
        },
        on_open = function(term)
          vim.cmd 'startinsert!'
          vim.keymap.set('n', 'q', '<cmd>close<CR>', { buffer = term.bufnr, noremap = true, silent = true })
        end,
        on_close = function()
          vim.cmd 'startinsert!'
        end,
      }

      local function lazygit_toggle()
        lazygit:toggle()
      end

      vim.keymap.set('n', '<leader>lg', lazygit_toggle, { desc = 'Open [L]azy[G]it', noremap = true, silent = true })

      -- Custom lazydocker terminal
      local lazydocker = Terminal:new {
        cmd = 'lazydocker',
        dir = vim.fn.getcwd(),
        direction = 'float',
        float_opts = {
          border = 'single',
        },
        on_open = function(term)
          vim.cmd 'startinsert!'
          vim.keymap.set('n', 'q', '<cmd>close<CR>', { buffer = term.bufnr, noremap = true, silent = true })
        end,
        on_close = function()
          vim.cmd 'startinsert!'
        end,
      }

      local function lazydocker_toggle()
        lazydocker:toggle()
      end

      vim.keymap.set('n', '<leader>ld', lazydocker_toggle, { desc = 'Open [L]azy[D]ocker', noremap = true, silent = true })
    end,
  },
}
