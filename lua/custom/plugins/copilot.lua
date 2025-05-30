-- copilot.lua
-- Sets up a performant Copilot session using a community-maintained, Lua-based plugin.
-- The GitHub-maintained Vim plugin is noticeably slower!
-- For more information, try :help Copilot

---@type LazyPluginSpec
return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  cond = function()
    return not vim.g.vsode and not vim.g.sops_engaged
  end,
  -- The plugin can be quite slow to start up - so only load it when entering Insert mode.
  event = 'InsertEnter',
  opts = {
    copilot_model = 'gpt-4.1-copilot',
    panel = {
      auto_refresh = true,
    },
    filetypes = {
      sh = function()
        if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), '^%.env.*') then
          -- disable for .env files
          return false
        end

        return true
      end,
    },
    suggestion = {
      -- Enable suggestions.
      enabled = true,
      -- Ensure suggestions appear while typing.
      auto_trigger = true,
      -- A pretty low debounce - perhaps too low for slow Internet connections.
      debounce = 25,
      -- After accepting a suggestion, automatically trigger the next one.
      trigger_on_accept = true,
      -- NOTE: The default keybindings don't really play nicely with existing mappings.
      keymap = {
        accept = '<C-a>',
        next = '<C-u>',
        prev = '<C-d>',
      },
    },
  },
}
