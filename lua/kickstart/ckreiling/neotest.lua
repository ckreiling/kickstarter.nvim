-- NOTE: Neotest config https://github.com/nvim-neotest/neotest
--
-- Run `:h neotest` to see docs!

return function(_config)
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

      -- I more frequently find I want to run the current tests in the current file
      -- and open the summary panel to rerun specific tests.
      local run_current_file = function()
        neotest.run.run(vim.fn.expand '%')
      end

      vim.keymap.set({ 'n' }, '<leader>ts', neotest.summary.toggle, { desc = '[T]est [S]ummary Panel' })
      vim.keymap.set({ 'n' }, '<leader>to', neotest.output_panel.toggle, { desc = '[T]est [O]utput Panel' })
      vim.keymap.set({ 'n' }, '<leader>tr', run_current_file, { desc = '[T]est [R]un Now' })
      vim.keymap.set({ 'n' }, '<leader>tc', neotest.run.stop, { desc = '[T]est [C]ancel Now' })
    end,
  }
end
