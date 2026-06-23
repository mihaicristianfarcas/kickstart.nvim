-- toggleterm.nvim: persistent, toggleable terminals.
--   <leader>\   toggle the main terminal (opens as a vertical split)
--   <leader>lg  floating lazygit       <leader>ld  floating lazydocker
-- Inside a terminal, <Esc><Esc> returns to normal mode; from there <leader>\
-- toggles it closed. In the lazygit/lazydocker floats, `q` closes the window.
return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      require('toggleterm').setup {
        size = function(term)
          if term.direction == 'horizontal' then
            return 30
          elseif term.direction == 'vertical' then
            return vim.o.columns * 0.5
          end
        end,
        direction = 'vertical',
        open_mapping = [[<leader>\]],
        -- Only map in normal mode. insert_mappings=false stops <Space>\ from
        -- being an insert-mode mapping, which otherwise makes every <Space>
        -- (the leader) stall for 'timeoutlen' while typing. terminal_mappings=
        -- false keeps terminal mode free too. Close from inside a terminal with
        -- <Esc><Esc> (to normal mode) then <leader>\.
        insert_mappings = false,
        terminal_mappings = false,
        shade_terminals = false,
      }

      local Terminal = require('toggleterm.terminal').Terminal

      -- Custom lazygit terminal
      local lazygit = Terminal:new {
        cmd = 'lazygit',
        dir = vim.fn.getcwd(),
        direction = 'float',
        float_opts = {
          border = 'rounded',
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
          border = 'rounded',
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
