return {

  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local alpha = require 'alpha'
      local dashboard = require 'alpha.themes.dashboard'

      -- Set header (ASCII art)
      dashboard.section.header.val = {
        [[     ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣿⣶⣿⣦⣼⣆          ]],
        [[      ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦       ]],
        [[            ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷    ⠻⠿⢿⣿⣧⣄     ]],
        [[             ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄    ]],
        [[            ⢠⣿⣿⣿⠈    ⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀   ]],
        [[     ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘  ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄  ]],
        [[    ⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄   ]],
        [[   ⣠⣿⠿⠛ ⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄  ]],
        [[   ⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇ ⠛⠻⢷⣄ ]],
        [[        ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆     ]],
        [[         ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃     ]],
      }
      dashboard.section.header.opts.position = 'center'

      -- Set menu buttons with kickstart.nvim keybindings
      dashboard.section.buttons.val = {
        dashboard.button('e', '  New file', '<cmd>ene <BAR> startinsert<CR>'),
        dashboard.button('c', '  Config', '<cmd>cd ~/.config/nvim | edit init.lua<CR>'),
        dashboard.button('l', '󰒲  Lazy', '<cmd>Lazy<CR>'),
        dashboard.button('m', '  Mason', '<cmd>Mason<CR>'),
        dashboard.button('q', '󰅚  Quit', '<cmd>qa<CR>'),
      }
      dashboard.section.buttons.opts.position = 'center'

      -- Customize button spacing and padding
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = 'AlphaButtons'
        button.opts.hl_shortcut = 'AlphaShortcut'
        button.opts.width = 52 -- Slightly wider buttons for centering
      end
      dashboard.section.buttons.opts.spacing = 1

      -- Set footer with plugin count
      local function footer()
        local total_plugins = #vim.tbl_keys(require('lazy').plugins())
        local datetime = os.date ' %d-%m-%Y   %H:%M:%S'
        local version = vim.version()
        local nvim_version_info = '   v' .. version.major .. '.' .. version.minor .. '.' .. version.patch

        return datetime .. '   ' .. total_plugins .. ' plugins' .. nvim_version_info
      end

      dashboard.section.footer.val = footer()
      dashboard.section.footer.opts.position = 'center'

      -- Layout configuration for better centering
      local function top_padding()
        local total_lines = vim.o.lines or 40
        return math.max(4, math.floor(total_lines * 0.2))
      end

      dashboard.config.layout = {
        { type = 'padding', val = top_padding() },
        dashboard.section.header,
        { type = 'padding', val = 1 },
        dashboard.section.buttons,
        { type = 'padding', val = 2 },
        dashboard.section.footer,
      }

      -- Set highlight groups
      dashboard.section.header.opts.hl = 'AlphaHeader'
      dashboard.section.buttons.opts.hl = 'AlphaButtons'
      dashboard.section.footer.opts.hl = 'AlphaFooter'

      -- Disable folding on alpha buffer
      vim.cmd [[
      autocmd FileType alpha setlocal nofoldenable
    ]]

      -- Apply configuration
      alpha.setup(dashboard.config)

      -- Close Lazy and re-open alpha when needed
      vim.api.nvim_create_autocmd('User', {
        pattern = 'LazyVimStarted',
        callback = function()
          local stats = require('lazy').stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.footer.val = '⚡ Neovim loaded ' .. stats.count .. ' plugins in ' .. ms .. 'ms'
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end, -- Apply configuration
  },
}
