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
      local ts_repeat = require 'nvim-treesitter-textobjects.repeatable_move'

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

      -- `s` still works as `cl` in normal mode; in x/o mode it selects a statement.
      -- `r` still works as "replace" in normal mode; in x/o mode it selects return.
      vim.keymap.set({ 'x', 'o' }, 's', function()
        select.select_textobject('@statement.outer', 'textobjects')
      end, { desc = 'Select [s]tatement' })
      vim.keymap.set({ 'x', 'o' }, 'S', function()
        select.select_textobject('@local.scope', 'locals')
      end, { desc = 'Select [S]cope' })
      vim.keymap.set({ 'x', 'o' }, 'r', function()
        select.select_textobject('@return.outer', 'textobjects')
      end, { desc = 'Select [r]eturn value' })
      vim.keymap.set({ 'x', 'o' }, 'R', function()
        select.select_textobject('@call.outer', 'textobjects')
      end, { desc = 'Select call e[R]pression' })

      -- ── Repeat last move (; / ,) ────────────────────────────────────────────
      -- Repeats treesitter textobject moves AND built-in f/F/t/T motions.
      -- f/F/t/T are mapped with `expr = true` so the module can track them.
      vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat.repeat_last_move_next, { desc = 'Repeat last move (forward)' })
      vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat.repeat_last_move_previous, { desc = 'Repeat last move (backward)' })
      vim.keymap.set('n', 'f', ts_repeat.builtin_f_expr, { expr = true, desc = 'f with repeat tracking' })
      vim.keymap.set('n', 'F', ts_repeat.builtin_F_expr, { expr = true, desc = 'F with repeat tracking' })
      vim.keymap.set('n', 't', ts_repeat.builtin_t_expr, { expr = true, desc = 't with repeat tracking' })
      vim.keymap.set('n', 'T', ts_repeat.builtin_T_expr, { expr = true, desc = 'T with repeat tracking' })
    end,
  },
}
