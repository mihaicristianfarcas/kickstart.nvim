return {
  -- The main event: LSP + DAP + Rust tooling
  {
    'mrcjkb/rustaceanvim',
    version = '^9',
    lazy = false, -- it lazy-loads itself by filetype; don't let lazy.nvim defer it
    config = function()
      vim.g.rustaceanvim = {
        server = {
          on_attach = function(client, bufnr)
            -- Rust-specific keymaps on top of kickstart's global LSP maps.
            -- RustLsp codeAction is strictly better than the generic vim.lsp one.
            vim.keymap.set('n', '<leader>ca', function()
              vim.cmd.RustLsp 'codeAction'
            end, { desc = 'Rust [C]ode [A]ction', buffer = bufnr })

            -- Hover with grouped actions (jump to docs, go to impl, etc.)
            vim.keymap.set('n', 'K', function()
              vim.cmd.RustLsp { 'hover', 'actions' }
            end, { desc = 'Rust Hover Actions', buffer = bufnr })
          end,
          default_settings = {
            ['rust-analyzer'] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                buildScripts = { enable = true },
              },
              -- Run clippy instead of plain `cargo check` on save
              checkOnSave = true,
              check = {
                command = 'clippy',
                extraArgs = { '--no-deps' },
              },
              procMacro = { enable = true },
              -- Rich inlay hints
              inlayHints = {
                bindingModeHints = { enable = true },
                closureReturnTypeHints = { enable = 'always' },
                lifetimeElisionHints = { enable = 'always', useParameterNames = true },
              },
            },
          },
        },
        -- DAP auto-configures itself if codelldb is installed via Mason
      }
    end,
  },

  -- Cargo.toml superpowers: version completion, update hints, crate docs
  {
    'saecki/crates.nvim',
    tag = 'stable',
    event = { 'BufRead Cargo.toml' },
    config = function()
      require('crates').setup()
    end,
  },
}
