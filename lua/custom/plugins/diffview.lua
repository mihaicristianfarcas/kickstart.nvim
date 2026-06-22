-- diffview.nvim: full-window git diff and file-history views.
--   <leader>gd  open diff of working tree     <leader>gc  close the diff view
--   <leader>gh  history of the current file   <leader>gH  history of the whole repo
--   <leader>gm  diff against the last commit (HEAD~1)
return {
  'sindrets/diffview.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory', 'DiffviewToggleFiles' },
  opts = {
    enhanced_diff_hl = true,
    view = {
      default = { layout = 'diff2_horizontal' },
      merge_tool = { layout = 'diff3_mixed' },
    },
    file_panel = {
      listing_style = 'tree',
      win_config = { position = 'left', width = 35 },
    },
  },
  keys = {
    { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = '[G]it [D]iff view' },
    { '<leader>gc', '<cmd>DiffviewClose<cr>', desc = '[G]it diff [C]lose' },
    { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = '[G]it file [H]istory' },
    { '<leader>gH', '<cmd>DiffviewFileHistory<cr>', desc = '[G]it repo [H]istory' },
    { '<leader>gm', '<cmd>DiffviewOpen HEAD~1<cr>', desc = '[G]it diff last co[M]mit' },
  },
}
