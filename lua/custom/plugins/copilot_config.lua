-- copilot_config.lua
-- A more detailed configuration and setup for Copilot.lua plugin.
-- This file enhances user experience and performance.

---@type LazyPluginSpec
return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  cond = function()
    return not vim.g.vsode and not vim.g.sops_engaged
  end,
  event = 'InsertEnter',
  opts = {
    copilot_model = 'gpt-4o-copilot',
    panel = {
      auto_refresh = true,
    },
    suggestion = {
      enabled = true,
      auto_trigger = true,
      debounce = 15, -- Reduced debounce for faster suggestions.
      keymap = {
        accept = '<C-y>', -- Changed to a more intuitive keybinding.
        next = '<C-n>', -- Changed to align with common navigation shortcuts.
        prev = '<C-p>', -- Changed to align with common navigation shortcuts.
        dismiss = '<C-e>', -- Added a dismiss keybinding for unwanted suggestions.
      },
    },
    filetypes = {
      python = true, -- Enable suggestions for Python files.
      lua = true, -- Enable suggestions for Lua files.
      javascript = true, -- Enable suggestions for JavaScript files.
      ['*'] = false, -- Disable for all other filetypes.
    },
  },
}
