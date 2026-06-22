-- vim-tmux-navigator: move between Neovim splits AND tmux panes with one set of
-- keys. <C-h/j/k/l> moves left/down/up/right; at the edge of Neovim's splits it
-- crosses into the adjacent tmux pane. Outside tmux it just moves between splits,
-- so these are the canonical window-navigation keys (init.lua intentionally does
-- not define its own <C-hjkl>).
return {
  {
    'christoomey/vim-tmux-navigator',
    cmd = {
      'TmuxNavigateLeft',
      'TmuxNavigateDown',
      'TmuxNavigateUp',
      'TmuxNavigateRight',
      'TmuxNavigatePrevious',
      'TmuxNavigatorProcessList',
    },
    keys = {
      { '<c-h>', '<cmd><C-U>TmuxNavigateLeft<cr>' },
      { '<c-j>', '<cmd><C-U>TmuxNavigateDown<cr>' },
      { '<c-k>', '<cmd><C-U>TmuxNavigateUp<cr>' },
      { '<c-l>', '<cmd><C-U>TmuxNavigateRight<cr>' },
    },
  },
}
