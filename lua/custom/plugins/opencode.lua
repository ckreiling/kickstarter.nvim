local toggle_key = '<C-,>'

---@module 'lazy'
---@type LazyPluginSpec
return {
  'NickvanDyke/opencode.nvim',
  dependencies = {
    'folke/snacks.nvim',
  },
  config = function()
    -- see here for options to vim.g.opencode_opts: https://github.com/NickvanDyke/opencode.nvim/blob/main/lua/opencode/config.lua
    ---@module 'opencode'
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      provider = {
        enabled = 'snacks',
        ---@module 'snacks'
        ---@type snacks.terminal.Opts
        snacks = {
          start_insert = true,
          win = {
            position = 'float',
            width = 0.9,
            height = 0.9,
            enter = true,
          },
        },
      },
      events = {
        -- don't prompt for permissions
        permissions = {
          enabled = false,
        },
      },
    }

    -- Required for `opts.events.reload`.
    vim.o.autoread = true

    vim.keymap.set({ 'n', 'x' }, '<C-a>', function()
      require('opencode').ask('@this: ', { submit = true })
    end, { desc = 'Ask opencode' })

    vim.keymap.set({ 'n', 'x' }, '<C-x>', function()
      require('opencode').select()
    end, { desc = 'Execute opencode action…' })

    vim.keymap.set({ 'n', 'x' }, '<leader>as', function()
      require('opencode').prompt '@this '
      vim.notify('🤖 Sent line(s) to opencode', vim.log.levels.INFO)
    end, { desc = 'Send lines to opencode' })

    vim.keymap.set({ 'n', 'x' }, '<leader>ab', function()
      require('opencode').prompt '@buffer'
      vim.notify('🤖 Sent buffer to opencode', vim.log.levels.INFO)
    end, { desc = 'Add buffer to opencode' })

    vim.keymap.set({ 'n', 'x' }, '<leader>ag', function()
      require('opencode').prompt '@buffers'
      vim.notify('🤖 Sent ALL buffers to opencode', vim.log.levels.INFO)
    end, { desc = 'Add all buffers to opencode' })

    vim.keymap.set({ 'n', 'x' }, '<leader>av', function()
      require('opencode').prompt '@visible'
      vim.notify('🤖 Sent visible text to opencode', vim.log.levels.INFO)
    end, { desc = 'Add visible text to opencode' })

    vim.keymap.set({ 'n', 'x' }, '<leader>ad', function()
      require('opencode').prompt '<git-diff>\n@diff</git-diff>\n\n'
      vim.notify('🤖 Sent git diff to opencode', vim.log.levels.INFO)
    end, { desc = 'Add git diff to opencode' })

    vim.keymap.set({ 'n', 't' }, toggle_key, function()
      require('opencode').toggle()
    end, { desc = 'Toggle opencode' })

    vim.keymap.set('n', '<S-C-u>', function()
      require('opencode').command 'session.half.page.up'
    end, { desc = 'opencode half page up' })

    vim.keymap.set('n', '<S-C-d>', function()
      require('opencode').command 'session.half.page.down'
    end, { desc = 'opencode half page down' })

    -- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o".
    vim.keymap.set('n', '+', '<C-a>', { desc = 'Increment', noremap = true })
    vim.keymap.set('n', '-', '<C-x>', { desc = 'Decrement', noremap = true })
  end,
}
