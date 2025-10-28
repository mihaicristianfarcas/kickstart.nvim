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
            return vim.o.columns * 0.25
          end
        end,
        direction = 'vertical',
        open_mapping = [[<C-\>]],
        shade_terminals = true,
      }

      -- Keymap to open horizontal terminals
      vim.keymap.set({ 'n', 't' }, '-<C-\\>', '<Cmd>ToggleTerm direction=horizontal<CR>', {
        desc = 'Open horizontal terminal',
        noremap = true,
        silent = true,
      })

      local Terminal = require('toggleterm.terminal').Terminal

      -- Custom lazygit terminal
      local lazygit = Terminal:new {
        cmd = 'lazygit',
        dir = vim.fn.getcwd(),
        direction = 'float',
        float_opts = {
          border = 'double',
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
    end,
  },
}
