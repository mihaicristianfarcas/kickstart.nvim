-- ============================================================================
-- init.lua — entry point. Loaded by Neovim on startup.
--
-- Layout:
--   1. Globals & leader        (this section)
--   2. [[ Options ]]           editor behaviour (vim.o / vim.opt)
--   3. [[ Basic Keymaps ]]     non-plugin keymaps + helpers
--   4. [[ Autocommands ]]      yank-highlight and friends
--   5. [[ Lazy.nvim ]]         bootstrap + the plugin list
--   6. Tail autocommands       auto-reload, transparent background, borders
--
-- Plugins live in two places:
--   - Inline in the require('lazy').setup({...}) call below (core editor stack).
--   - One file per plugin under lua/custom/plugins/, auto-imported at the end
--     of the list via { import = 'custom.plugins' }.
--
-- Leader is <Space>. Press it and wait to let which-key show what's available.
-- ============================================================================

-- Leader key must be set before plugins load (so plugin mappings see <Space>)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- [[ Options ]]

vim.o.number = true -- absolute number on the cursor line
vim.o.relativenumber = true -- relative numbers elsewhere (easy {count}j/k)
vim.o.mouse = 'a' -- mouse enabled in all modes
vim.o.showmode = false -- mode is shown in the statusline instead

-- Use the system clipboard for all yanks/pastes. Scheduled so it doesn't slow
-- startup (clipboard providers can be expensive to probe).
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

vim.o.breakindent = true -- wrapped lines keep their indent
vim.o.undofile = true -- persist undo history across sessions
vim.o.ignorecase = true -- case-insensitive search...
vim.o.smartcase = true -- ...unless the query contains an uppercase letter
vim.o.signcolumn = 'yes' -- always show the sign column (no text jitter)
vim.o.updatetime = 250 -- ms of idle before CursorHold / swap write
vim.o.timeoutlen = 300 -- ms to wait for a mapped sequence to complete
vim.o.splitright = true -- vertical splits open to the right
vim.o.splitbelow = true -- horizontal splits open below
vim.o.list = true -- render whitespace using listchars below
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.o.inccommand = 'split' -- live preview of :substitute in a split
vim.o.cursorline = true -- highlight the current line
vim.o.scrolloff = 10 -- keep 10 lines of context above/below the cursor
vim.o.confirm = true -- prompt to save instead of failing on :q with changes

-- [[ Basic Keymaps ]]

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Split navigation with CTRL+<hjkl> is handled by vim-tmux-navigator
-- (see lua/custom/plugins/vim-tmux-navigator.lua), which also integrates with
-- tmux panes and falls back to plain window navigation outside tmux.

-- Move lines up/down
vim.keymap.set('n', '<M-up>', ':m .-2<CR>==', { desc = 'Move line up', silent = true })
vim.keymap.set('n', '<M-down>', ':m .+1<CR>==', { desc = 'Move line down', silent = true })
vim.keymap.set('n', '<M-k>', ':m .-2<CR>==', { desc = 'Move line up', silent = true })
vim.keymap.set('n', '<M-j>', ':m .+1<CR>==', { desc = 'Move line down', silent = true })
vim.keymap.set('v', '<M-up>', ":m '<-2<CR>gv=gv", { desc = 'Move block up', silent = true })
vim.keymap.set('v', '<M-down>', ":m '>+1<CR>gv=gv", { desc = 'Move block down', silent = true })
vim.keymap.set('v', '<M-k>', ":m '<-2<CR>gv=gv", { desc = 'Move block up', silent = true })
vim.keymap.set('v', '<M-j>', ":m '>+1<CR>gv=gv", { desc = 'Move block down', silent = true })

-- Navigation with screen centering
vim.keymap.set('n', '<C-u>', '<C-u>zz', { silent = true })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { silent = true })

-- Replace with already-copied text (without overwriting register)
vim.keymap.set('x', '<leader>p', '"_dP', { desc = 'Replace with copied text', silent = true })

-- Copy file path with line number to clipboard
vim.keymap.set({ 'n', 'v' }, '<leader>sc', function()
  local filepath = vim.fn.expand '%'
  local start_line = vim.fn.line '.'
  local end_line = vim.fn.line 'v'
  local text

  if vim.fn.mode() == 'v' or vim.fn.mode() == 'V' or vim.fn.mode() == '\22' then
    start_line = vim.fn.line 'v'
    end_line = vim.fn.line '.'
    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end
    text = string.format('%s:%d-%d', filepath, start_line, end_line)
  else
    text = string.format('%s:%d', filepath, start_line)
  end
  vim.fn.setreg('+', text)
  vim.notify('Copied: ' .. text, vim.log.levels.INFO)
end, { desc = '[S]election [C]opy (file path with line number/range)' })

-- [[ Autocommands ]]

-- Highlight when yanking text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- [[ Lazy.nvim plugin manager ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- [[ Plugins ]]
require('lazy').setup({
  'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically

  -- Git change signs in the gutter (+ / ~ / _). The hunk-staging keymaps
  -- (<leader>h..., ]c/[c) are added separately in lua/kickstart/plugins/gitsigns.lua;
  -- this block only sets the sign characters.
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  -- which-key: after pressing a prefix (e.g. <Space>) a popup lists the
  -- available follow-up keys. The `spec` at the bottom names the leader groups
  -- so they read as words ("[S]earch") instead of a bare letter.
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      delay = 0,
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Leader-prefix group labels. Add a line here whenever a new <leader>X...
      -- family of mappings is introduced so the which-key popup stays readable.
      spec = {
        { '<leader>s', group = '[S]earch' }, -- telescope pickers
        { '<leader>t', group = '[T]oggle' }, -- toggles (inlay hints, blame, context)
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } }, -- gitsigns
        { '<leader>g', group = '[G]it' }, -- diffview
        { '<leader>x', group = 'Diagnostics' }, -- trouble
        { '<leader>S', group = '[S]ession' }, -- persistence
        { '<leader>l', group = '[L]azygit/Docker' }, -- toggleterm floats
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } }, -- LSP/rust code actions
        { 'gs', group = '[S]urround', mode = { 'n', 'x' } }, -- mini.surround (non-leader)
      },
    },
  },

  -- Telescope: fuzzy finder for files, live grep, help, keymaps, LSP symbols,
  -- diagnostics, etc. All pickers are bound under <leader>s... (+ <leader><leader>
  -- for buffers and <leader>/ for the current buffer). fzf-native speeds up
  -- sorting; ui-select routes vim.ui.select (e.g. code actions) through Telescope.
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        defaults = {
          file_ignore_patterns = {
            'node_modules/',
            '.git/',
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Search Neovim config files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files {
          cwd = vim.fn.stdpath 'config',
          -- hidden = true,
          no_ignore = false,
        }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  -- LSP Plugins

  -- lazydev: makes the Lua language server understand the Neovim runtime, so
  -- editing this config gets completion/docs for the `vim.*` API. Lua files only.
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  -- LSP: nvim-lspconfig wires up language servers. Mason installs the servers
  -- and CLI tools (formatters/linters); mason-lspconfig auto-installs a server
  -- when you open a matching filetype; blink.cmp supplies completion capabilities.
  -- The `servers` table below is the list to configure — add an entry to enable one.
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', opts = { ui = { border = 'rounded' } } },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'saghen/blink.cmp',
    },
    config = function()
      -- Runs every time a language server attaches to a buffer. Everything here
      -- is buffer-local, so these keymaps only exist where an LSP is active.
      -- Mnemonic: most LSP actions live under `gr` (goto/refactor).
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
          map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
          map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

          -- Nvim 0.11 compatibility helper
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- Highlight references under cursor
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- Toggle inlay hints
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Diagnostic config
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            return diagnostic.message
          end,
        },
      }

      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- LSP servers to install/configure. Add more as needed.
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = 'Replace' },
            },
          },
        },
        gopls = {},
        pyright = {},
        clangd = {},
        -- Rust is handled by rustaceanvim (see lua/custom/plugins/rustaceanvim.lua)
      }

      -- Tools to ensure installed via mason-tool-installer (LSPs + formatters + linters)
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Lua formatter
        'goimports', -- Go imports/format
        'gofumpt', -- Go stricter formatter
        'golangci-lint', -- Go linter
        'ruff', -- Python formatter + linter
        'clang-format', -- C/C++ formatter
        'markdownlint', -- Markdown linter
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        ensure_installed = {},
        automatic_installation = true, -- Auto-install LSPs when opening files (like Treesitter's auto_install)
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  -- conform: runs external formatters. Formats on save (per-filetype list in
  -- `formatters_by_ft`) and on demand with <leader>f. Falls back to the LSP
  -- formatter when no dedicated formatter is configured for the filetype.
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = {}
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        end
        return { timeout_ms = 500, lsp_format = 'fallback' }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = { 'biome' },
        typescript = { 'biome' },
        go = { 'goimports', 'gofumpt' },
        python = { 'ruff_organize_imports', 'ruff_format' },
        c = { 'clang-format' },
        cpp = { 'clang-format' },
      },
    },
  },

  -- blink.cmp: the completion engine (the popup as you type). Sources are LSP,
  -- file paths, snippets (LuaSnip), and lazydev. `preset = 'default'` keeps the
  -- stock keys: <C-y> accept, <C-n>/<C-p> or arrows to cycle, <C-space> toggle.
  {
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        opts = {},
      },
      'folke/lazydev.nvim',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = { preset = 'default' },

      appearance = { nerd_font_variant = 'mono' },
      completion = { documentation = { auto_show = true, auto_show_delay_ms = 500 } },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },
      snippets = { preset = 'luasnip' },
      fuzzy = { implementation = 'lua' },
      signature = { enabled = true },
    },
  },

  -- Highlights and lists TODO/FIXME/HACK/NOTE comments. (signs off = no gutter icons.)
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  -- mini.nvim: a collection of small modules. Only the four set up below are
  -- enabled; each `require('mini.x').setup` is independent.
  {
    'echasnovski/mini.nvim',
    config = function()
      -- mini.ai: smarter a/i text objects (e.g. around/inside function, argument,
      -- quotes). n_lines caps how far it searches for a matching pair.
      require('mini.ai').setup { n_lines = 500 }

      -- mini.surround: add/delete/replace surrounding pairs, under the `s` prefix
      --   saiw)  surround inner-word with parentheses
      --   sd)    delete surrounding parentheses
      --   sr)(   replace surrounding ) with (
      require('mini.surround').setup {
        mappings = {
          add = 'sa',
          delete = 'sd',
          find = 'sf',
          find_left = 'sF',
          highlight = 'sh',
          replace = 'sr',
          update_n_lines = 'sn',
        },
      }

      -- mini.comment: toggle comments with `gc` (operator/visual) and `gcc`
      -- (current line). Uses each filetype's commentstring.
      require('mini.comment').setup()

      -- mini.statusline: the statusline. The override makes the location section
      -- read as LINE:COLUMN with fixed width.
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },

  -- Treesitter: builds a syntax tree per buffer, powering accurate highlighting,
  -- indentation, and the text objects/motions in treesitter-textobjects.nvim.
  -- Add a language to the `parsers` list to have its parser installed on startup.
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      -- Ensure each parser is available; install it on the fly if missing.
      require('nvim-treesitter.install').prefer_git = true
      local parsers = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'rust',
        'toml',
        'go',
        'gomod',
        'gosum',
        'python',
      }
      for _, parser in ipairs(parsers) do
        local ok, _ = pcall(vim.treesitter.language.add, parser)
        if not ok then
          vim.cmd('TSInstall ' .. parser)
        end
      end
    end,
  },

  -- Plugin specs kept in their own files under lua/kickstart/plugins/.
  require 'kickstart.plugins.debug', -- nvim-dap debugging (F-keys, <leader>b)
  require 'kickstart.plugins.autopairs', -- auto-close brackets/quotes
  require 'kickstart.plugins.gitsigns', -- gitsigns hunk keymaps (see note above)

  -- Auto-import every file in lua/custom/plugins/. This is where personal
  -- plugins live — drop a new `name.lua` returning a lazy spec and it loads.
  { import = 'custom.plugins' },
}, {
  ui = {
    border = 'rounded',
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- Auto-reload files changed on disk outside Neovim (e.g. by git or a formatter).
-- `checktime` re-reads the file if it changed and the buffer has no edits; the
-- guard skips it while in command-line mode / the cmdline window.
vim.o.autoread = true
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'TermEnter', 'TermLeave', 'CursorHold', 'CursorHoldI' }, {
  callback = function()
    if vim.fn.mode() ~= 'c' and vim.fn.getcmdwintype() == '' then
      vim.api.nvim_command 'checktime'
    end
  end,
})

-- Notify when a buffer was reloaded because the file changed externally.
vim.api.nvim_create_autocmd('FileChangedShellPost', {
  callback = function()
    vim.api.nvim_echo({ { 'File reloaded (changed externally)', 'WarningMsg' } }, true, {})
  end,
})

-- Transparent background: clear the background of the core highlight groups so
-- the terminal's own background (and any transparency) shows through. Re-applied
-- on every colorscheme change and once on startup.
local function set_transparent_bg()
  local groups = {
    'Normal',
    'NormalNC',
    'SignColumn',
    'NormalFloat',
    'FloatBorder',
    'EndOfBuffer',
    'WinSeparator',
  }
  for _, group in ipairs(groups) do
    vim.api.nvim_set_hl(0, group, { bg = 'none', ctermbg = 'none' })
  end
end

-- Apply after colorscheme loads and on every colorscheme change
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = '*',
  callback = set_transparent_bg,
})

-- Also apply on VimEnter to ensure it runs after init
vim.api.nvim_create_autocmd('VimEnter', {
  callback = set_transparent_bg,
})

-- Default rounded border for all floating windows (hovers, diagnostics, etc.).
vim.o.winborder = 'rounded'
