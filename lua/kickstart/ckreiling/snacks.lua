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
    dashboard = {
      sections = {
        { section = 'header' },
        { section = 'keys', gap = 1, padding = 1 },
        { pane = 2, icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
        { pane = 2, icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
        {
          pane = 2,
          icon = ' ',
          title = 'Git Status',
          section = 'terminal',
          enabled = function()
            return Snacks.git.get_root() ~= nil
          end,
          cmd = 'git status --short --branch --renames',
          height = 5,
          padding = 1,
          ttl = 5 * 60,
          indent = 3,
        },
        { section = 'startup' },
      },
    },
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
