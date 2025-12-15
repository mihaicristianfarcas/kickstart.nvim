return {
  {
    'mihaicristianfarcas/nvim-search-and-replace',
    cmd = { 'SearchAndReplaceOpen', 'SearchAndReplaceVisual', 'SearchAndReplaceUndo', 'SearchAndReplaceRedo' },
    keys = {
      { '<leader>sar', '<cmd>SearchAndReplaceOpen<cr>', desc = '[S]earch [A]nd [R]eplace' },
      { '<leader>saw', '<cmd>SearchAndReplaceVisual<cr>', desc = '[S]earch [A]nd replace [W]ord' },
    },
    opts = {
      -- General options
      smart_case = true, -- Case insensitive unless uppercase is used
      max_results = 10000, -- Maximum number of search results to display
      max_file_size = '1M', -- Skip files larger than this (ripgrep format: K, M, G)

      -- Keymap customization (overrides defaults)
      keymap = {
        -- Help
        help = { keys = { '?', '<F1>' }, description = 'Toggle this help window' },

        -- Navigation
        next_field = { keys = { '<CR>', '<Tab>' }, description = 'Move to next field' },
        prev_field = { keys = { '<S-Tab>' }, description = 'Move to previous field' },
        jump_search = { keys = { 'i', 'a' }, description = 'Jump to search field' },
        jump_replace = { keys = { 'I' }, description = 'Jump to replace field' },

        -- Selection (in results)
        visual_select = { keys = { 'v', 'V' }, description = 'Visual mode to select multiple results' },

        -- Actions
        replace_selected = { keys = { '<CR>' }, description = 'Replace current (or all marked items)' },
        replace_all = { keys = { '<C-a>' }, description = 'Replace ALL matches' },
        open_in_file = { keys = { 'o' }, description = 'Open current result in file' },
        stop_search = { keys = { '<C-x>' }, description = 'Stop/abort current search' },
        undo = { keys = { 'u', '<C-z>' }, description = 'Undo last replacement' },
        redo = { keys = { '<C-r>', '<C-S-z>' }, description = 'Redo last replacement' },

        -- Window
        close = { keys = { '<Esc>', 'q' }, description = 'Close' },
      },
    },
  },
}
