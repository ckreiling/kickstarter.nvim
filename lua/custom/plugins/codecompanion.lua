---@type LazyPluginSpec
return {
  'olimorris/codecompanion.nvim',
  -- NOTE: by default, this plugin uses the `copilot` adapter.
  --
  -- This config doesn't conditionally try to use any other type of adapter, but
  -- it could easily be added.
  opts = {
    strategies = {
      chat = {
        keymaps = {
          -- Override the default 'q' mapping to toggle instead of stop
          toggle_chat = {
            modes = { n = 'q' },
            description = 'Toggle chat buffer',
            callback = function()
              require('codecompanion').toggle()
            end,
          },
          -- Move the stop functionality to another key, since 'q' is taken
          stop = {
            modes = { n = '<C-q>' },
            description = 'Stop current request',
          },
        },
      },
    },
    extensions = {
      mcphub = {
        callback = 'mcphub.extensions.codecompanion',
        opts = {
          show_result_in_chat = true, -- Show mcp tool results in chat
          make_vars = true, -- Convert resources to #variables
          make_slash_commands = true, -- Add prompts as /slash commands
        },
      },
      history = {
        enabled = true,
        opts = {},
      },
    },
  },
  cond = function()
    return not vim.g.vsode and not vim.g.sops_engaged
  end,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'ravitemer/codecompanion-history.nvim',
    'ravitemer/mcphub.nvim',
    'MeanderingProgrammer/render-markdown.nvim',
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
    {
      '<leader>cch',
      '<cmd>CodeCompanionHistory<CR>',
      desc = '[C]ode [C]ompanion [H]istory',
    },
  },
}
