-- copilot.lua
-- Sets up a performant Copilot session using a community-maintained, Lua-based plugin.
-- The GitHub-maintained Vim plugin is noticeably slower!
-- For more information, try :help Copilot

return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  -- The plugin can be quite slow to start up - so only load it when entering Insert mode.
  event = 'InsertEnter',
  opts = {
    suggestion = {
      -- Enable suggestions.
      enabled = true,
      -- Ensure suggestions appear while typing.
      auto_trigger = true,
      -- A pretty low debounce - perhaps too low for slow Internet connections.
      debounce = 25,
      -- NOTE: The default keybindings don't really play nicely with existing mappings.
      keymap = {
        accept = '<C-a>',
        next = '<C-\\',
        previous = '<C-[>',
      },
    },
  },
}
