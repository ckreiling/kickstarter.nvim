---@type LazyPluginSpec
return {
  'olimorris/codecompanion.nvim',
  -- NOTE: by default, this plugin uses the `copilot` adapter.
  --
  -- This config doesn't conditionally try to use any other type of adapter, but
  -- it could easily be added.
  opts = {
    extensions = {
      mcphub = {
        callback = 'mcphub.extensions.codecompanion',
        opts = {
          show_result_in_chat = true, -- Show mcp tool results in chat
          make_vars = true, -- Convert resources to #variables
          make_slash_commands = true, -- Add prompts as /slash commands
        },
      },
    },
  },
  cond = function()
    return not vim.g.vsode and not vim.g.sops_engaged
  end,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    {
      'ravitemer/mcphub.nvim',
      dependencies = {
        'nvim-lua/plenary.nvim',
      },
      build = 'bundled_build.lua',
      config = function()
        require('mcphub').setup {
          use_bundled_binary = true,
        }
      end,
    },
    {
      'MeanderingProgrammer/render-markdown.nvim',
      ft = { 'markdown', 'codecompanion' },
    },
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
