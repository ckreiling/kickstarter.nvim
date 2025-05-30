---@type LazyPluginSpec
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  cond = function()
    return not vim.g.vscode
  end,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    notifier = {},
    words = { enabled = true },
    statuscolumn = {},
    terminal = {},
    input = {
      enabled = true,
      -- Add these specific options for better styling
      win = {
        relative = 'cursor',
        row = 1,
        col = 0,
        border = 'rounded',
        title_pos = 'center',
      },
    },
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
        Snacks.gitbrowse()
      end,
      desc = '[G]it [B]rowse',
    },
    {
      '<leader>tt',
      function()
        Snacks.terminal.toggle '/bin/zsh'
      end,
      desc = '[T]oggle [T]erminal',
    },
    {
      '<leader>gg',
      function()
        Snacks.lazygit()
      end,
      desc = '[G]it [G]ui',
    },
  },
}
