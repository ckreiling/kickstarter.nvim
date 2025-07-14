-- NOTE: Neotest config https://github.com/nvim-neotest/neotest
--
-- Run `:h neotest` to see docs!

---@type LazyPluginSpec
return {
  'nvim-neotest/neotest',
  cond = function()
    return not vim.g.vscode
  end,
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',

    -- Python adapter
    'nvim-neotest/neotest-python',

    -- WARN: The vim-test adapter is missing a lot of features
    --
    -- Uncomment if maybe you encounter a test runner that doesn't have a neotest adapter

    -- 'vim-test/vim-test',
    -- 'nvim-neotest/neotest-vim-test',
  },
  keys = {
    {
      '<leader>ts',
      function()
        require('neotest').summary.toggle()
      end,
      desc = '[T]est [S]ummary Panel',
    },
    {
      '<leader>to',
      function()
        require('neotest').output_panel.toggle()
      end,
      desc = '[T]est [O]utput Panel',
    },
    {
      '<leader>tr',
      function()
        require('neotest').run.run(vim.fn.expand '%')
      end,
      desc = '[T]est [R]un Now',
    },
    {
      '<leader>tc',
      function()
        require('neotest').run.stop()
      end,
      desc = '[T]est [C]ancel Now',
    },
  },
  config = function()
    local neotest = require 'neotest'

    neotest.setup {
      adapters = {
        require 'neotest-python',

        -- WARN: See comment above about vim-test adapter
        --
        -- require 'neotest-vim-test' { ignore_filetypes = { 'python' } },
      },
    }
  end,
}
