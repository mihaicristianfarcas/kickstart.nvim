return {
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    event = { 'BufReadPost', 'BufNewFile' },
    init = function()
      -- Disable built-in ftplugin mappings so they don't shadow the global
      -- text-object/movement maps defined below (built-in ftplugin maps are
      -- buffer-local and would otherwise win over our global ones).
      -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin
      vim.g.no_plugin_maps = true
    end,
    config = function()
      require('nvim-treesitter-textobjects').setup {
        select = {
          -- Jump forward to the text object if the cursor is before it.
          lookahead = true,
          selection_modes = {
            ['@function.outer'] = 'V', -- linewise
            ['@class.outer'] = 'V', -- linewise
            ['@parameter.outer'] = 'v', -- charwise
          },
          include_surrounding_whitespace = false,
        },
        move = {
          set_jumps = true, -- push moves to the jumplist
        },
      }

      local select = require 'nvim-treesitter-textobjects.select'
      local move = require 'nvim-treesitter-textobjects.move'
      local swap = require 'nvim-treesitter-textobjects.swap'

      -- ── Select (operator-pending + visual) ────────────────────────────────
      -- Keys are deliberately off mini.ai's `af`/`aa`/`at` and use `m` for
      -- "method/function" (the upstream convention) to avoid clashes.
      local sel = {
        ['am'] = { '@function.outer', 'a [m]ethod / function' },
        ['im'] = { '@function.inner', 'inner [m]ethod / function' },
        ['ac'] = { '@class.outer', 'a [c]lass' },
        ['ic'] = { '@class.inner', 'inner [c]lass' },
        ['al'] = { '@loop.outer', 'a [l]oop' },
        ['il'] = { '@loop.inner', 'inner [l]oop' },
        ['ak'] = { '@conditional.outer', 'a conditional (bloc[k])' },
        ['ik'] = { '@conditional.inner', 'inner conditional (bloc[k])' },
        ['a/'] = { '@comment.outer', 'a comment' },
        ['aP'] = { '@parameter.outer', 'a [P]arameter' },
        ['iP'] = { '@parameter.inner', 'inner [P]arameter' },
        ['aS'] = { '@local.scope', 'a [S]cope', 'locals' },
      }
      for lhs, spec in pairs(sel) do
        local query, desc, group = spec[1], spec[2], spec[3] or 'textobjects'
        vim.keymap.set({ 'x', 'o' }, lhs, function()
          select.select_textobject(query, group)
        end, { desc = 'Select ' .. desc })
      end

      -- ── Swap (normal) ─────────────────────────────────────────────────────
      -- Alt+h/l "shove" the parameter/argument under the cursor left/right.
      vim.keymap.set('n', '<M-l>', function()
        swap.swap_next '@parameter.inner'
      end, { desc = 'Swap parameter with next' })
      vim.keymap.set('n', '<M-h>', function()
        swap.swap_previous '@parameter.inner'
      end, { desc = 'Swap parameter with previous' })

      -- ── Move (normal + visual + operator-pending) ─────────────────────────
      -- `]c`/`[c` are intentionally left to gitsigns (hunks).
      local moves = {
        goto_next_start = {
          [']f'] = { '@function.outer', 'Next function start' },
          [']]'] = { '@class.outer', 'Next class start' },
          [']l'] = { '@loop.outer', 'Next loop start' },
          [']a'] = { '@parameter.inner', 'Next parameter' },
        },
        goto_next_end = {
          [']F'] = { '@function.outer', 'Next function end' },
          [']['] = { '@class.outer', 'Next class end' },
        },
        goto_previous_start = {
          ['[f'] = { '@function.outer', 'Previous function start' },
          ['[['] = { '@class.outer', 'Previous class start' },
          ['[l'] = { '@loop.outer', 'Previous loop start' },
          ['[a'] = { '@parameter.inner', 'Previous parameter' },
        },
        goto_previous_end = {
          ['[F'] = { '@function.outer', 'Previous function end' },
          ['[]'] = { '@class.outer', 'Previous class end' },
        },
      }
      for fn, maps in pairs(moves) do
        for lhs, spec in pairs(maps) do
          local query, desc = spec[1], spec[2]
          vim.keymap.set({ 'n', 'x', 'o' }, lhs, function()
            move[fn](query, 'textobjects')
          end, { desc = desc })
        end
      end

      -- Note: `;`/`,` and `f`/`F`/`t`/`T` repeat are intentionally NOT remapped
      -- to nvim-treesitter-textobjects' repeatable_move, because flash.nvim's
      -- char mode already owns those keys.
    end,
  },
}
