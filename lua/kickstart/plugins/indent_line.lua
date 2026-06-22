-- NOT LOADED: this file isn't imported in init.lua, so indent-blankline is
-- inactive. To enable indentation guides, add
-- `require 'kickstart.plugins.indent_line',` to the plugin list in init.lua.
return {
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
  },
}
