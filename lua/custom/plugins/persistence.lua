return {
  'folke/persistence.nvim',
  event = 'BufReadPre', -- only start session saving once an actual file is opened
  opts = {
    need = 1, -- minimum number of file buffers needed to save the session
    branch = true, -- save a separate session per git branch
  },
  keys = {
    { '<leader>Ss', function() require('persistence').load() end, desc = '[S]ession restore (cwd)' },
    { '<leader>Sl', function() require('persistence').load { last = true } end, desc = '[S]ession restore [l]ast' },
    { '<leader>SS', function() require('persistence').select() end, desc = '[S]ession [S]elect' },
    { '<leader>Sd', function() require('persistence').stop() end, desc = "[S]ession [d]on't save" },
  },
}
