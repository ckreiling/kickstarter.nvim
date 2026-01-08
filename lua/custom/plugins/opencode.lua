local toggle_key = '<C-,>'

-- Map Neovim background to OpenCode theme
-- OpenCode's "system" theme doesn't work in Neovim's terminal (Node.js doesn't detect TTY)
-- so we dynamically set the theme based on vim.o.background via OPENCODE_CONFIG_CONTENT
local function get_opencode_theme()
  return vim.o.background == 'light' and 'gruvbox' or 'tokyonight'
end

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

    -- Dynamically update theme env var before each toggle
    -- This ensures the theme matches vim.o.background at the time opencode is opened
    local original_toggle = require('opencode').toggle
    require('opencode').toggle = function(...)
      ---@module 'opencode.provider.snacks'
      local provider = require('opencode.config').provider
      if provider and provider.opts then
        provider.opts.env = provider.opts.env or {}
        provider.opts.env.OPENCODE_CONFIG_CONTENT = vim.json.encode { theme = get_opencode_theme() }
      end
      return original_toggle(...)
    end

    -- Required for `opts.events.reload`.
    vim.o.autoread = true

    local function opencode_notify(message, level)
      level = level or vim.log.levels.INFO
      Snacks.notifier.notify(message, level, { title = 'Opencode', icon = '🤖', style = 'fancy' })
    end

    vim.keymap.set({ 'n', 'x' }, '<C-a>', function()
      require('opencode').ask('@this: ', { submit = true })
    end, { desc = 'Ask opencode' })

    vim.keymap.set({ 'n', 'x' }, '<C-x>', function()
      require('opencode').select()
    end, { desc = 'Execute opencode action…' })

    vim.keymap.set({ 'n', 'x' }, '<leader>as', function()
      require('opencode').prompt '@this '
      opencode_notify 'Sent line(s) to opencode'
    end, { desc = 'Send lines to opencode' })

    vim.keymap.set({ 'n', 'x' }, '<leader>ab', function()
      require('opencode').prompt '@buffer'
      opencode_notify 'Sent buffer to opencode'
    end, { desc = 'Add buffer to opencode' })

    vim.keymap.set({ 'n', 'x' }, '<leader>ag', function()
      require('opencode').prompt '@buffers'
      opencode_notify 'Sent ALL buffers to opencode'
    end, { desc = 'Add all buffers to opencode' })

    vim.keymap.set({ 'n', 'x' }, '<leader>av', function()
      require('opencode').prompt '@visible'
      opencode_notify 'Sent visible text to opencode'
    end, { desc = 'Add visible text to opencode' })

    vim.keymap.set({ 'n', 'x' }, '<leader>ad', function()
      require('opencode').prompt '<git-diff>\n@diff</git-diff>\n\n'
      opencode_notify 'Sent git diff to opencode'
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

    -- Subscribe to events and emit notifications, or whatever!
    vim.api.nvim_create_autocmd('User', {
      pattern = 'OpencodeEvent:*',
      callback = function(args)
        -- uncomment for notifications of every event
        -- vim.notify(vim.inspect(event))

        -- a tad leaky, hopefully this doesn't break
        ---@module 'opencode.provider.snacks'
        -- if the opencode terminal isn't closed then I'm watching it happen
        local opencode_provider_snacks = require('opencode.config').provider
        if not opencode_provider_snacks:get().closed then
          return
        end

        ---@type opencode.cli.client.Event
        local event = args.data.event

        if event.type == 'session.idle' then
          opencode_notify '💤 Awaiting Input'
        end

        if event.type == 'session.error' then
          opencode_notify('❌ Error in Opencode', vim.log.levels.ERROR)
        end

        if event.type == 'file.edited' then
          local file = vim.fn.fnamemodify(event.properties.file, ':.')

          -- Depending on the buffer, slightly alter the message
          if vim.api.nvim_buf_get_name(0) == event.properties.file then
            opencode_notify '✏️ Edited current buffer'
          elseif vim.fn.bufexists(event.properties.file) == 1 then
            opencode_notify('✏️ Edited another open buffer:\n\n' .. file)
          else
            opencode_notify('✏️ Edited unopened file:\n\n' .. file)
          end
        end
      end,
    })
  end,
}
