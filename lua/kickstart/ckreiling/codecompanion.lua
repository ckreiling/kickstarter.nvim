---@type LazyPluginSpec
return {
  'olimorris/codecompanion.nvim',
  -- NOTE: by default, this plugin uses the `copilot` adapter.
  --
  -- This config doesn't conditionally try to use any other type of adapter, but
  -- it could easily be added.
  opts = {},
  cond = function()
    return not vim.g.vsode and not vim.g.sops_engaged
  end,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  keys = {
    {
      '<leader>cct',
      function()
        require('codecompanion').toggle()
      end,
      desc = '[C]ode [C]ompanion [T]oggle',
    },
    {
      '<leader>ccc',
      function()
        require('codecompanion').chat()
      end,
      desc = '[C]ode [C]ompanion [C]hat',
    },
    {
      '<leader>cca',
      function()
        require('codecompanion').actions {}
      end,
      desc = '[C]ode [C]ompanion [A]ctions',
    },
  },
}
