-- flash.nvim: jump anywhere on screen by typing a few characters and then a
-- label letter. Also upgrades f/F/t/T to show labels.
--   s   jump (normal/visual/operator)         S   jump to a treesitter node
--   r   remote jump (operator-pending)        R   treesitter search
--   <c-s> toggle flash while searching (/)
-- Note: `s` is owned by flash here, which is why mini.surround uses the `gs`
-- prefix instead (see init.lua).
return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  ---@type Flash.Config
  opts = {
    labels = 'asdfghjklqwertyuiopzxcvbnm',
    search = {
      multi_window = true,
      forward = true,
      wrap = true,
    },
    jump = {
      jumplist = true,
      pos = 'start',
      autojump = false,
    },
    label = {
      uppercase = false,
      rainbow = { enabled = false },
    },
    modes = {
      search = { enabled = false }, -- Don't override regular search
      char = { enabled = true }, -- Enhanced f/F/t/T motions
      treesitter = {
        labels = 'asdfghjklqwertyuiopzxcvbnm',
        jump = { pos = 'range' },
        label = { before = true, after = true },
      },
    },
  },
  keys = {
    {
      's',
      mode = { 'n', 'x', 'o' },
      function()
        require('flash').jump()
      end,
      desc = 'Flash jump',
    },
    {
      'S',
      mode = { 'n', 'x', 'o' },
      function()
        require('flash').treesitter()
      end,
      desc = 'Flash Treesitter select',
    },
    {
      'r',
      mode = 'o',
      function()
        require('flash').remote()
      end,
      desc = 'Remote Flash',
    },
    {
      'R',
      mode = { 'o', 'x' },
      function()
        require('flash').treesitter_search()
      end,
      desc = 'Treesitter Search',
    },
    {
      '<c-s>',
      mode = { 'c' },
      function()
        require('flash').toggle()
      end,
      desc = 'Toggle Flash Search',
    },
  },
}
