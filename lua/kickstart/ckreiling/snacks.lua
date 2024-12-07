return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.config
  opts = {
    bigfile = { enabled = true },
    notifier = {},
    words = { enabled = true },
    statuscolumn = {},
    dashboard = {},
    gitbrowse = {},
  },
  keys = {
    {
      '<leader>gB',
      function()
        require('snacks').gitbrowse()
      end,
      desc = '[G]it [B]rowse',
    },
  },
}
