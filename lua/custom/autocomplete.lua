local M = {}

-- Change this to edit the default autocomplete plugin
-- Unfortunately toggling this at runtime is pretty painful if we want them
-- both to use the same keybindings. Basically we can enable/disable the completions
-- but it's very difficult to get "transfer" the keybindings to the other plugin.
-- local default = 'copilot'
local default = 'windsurf'
M.backend = os.getenv 'NVIM_AUTOCOMPLETE' or default

if M.backend ~= 'copilot' and M.backend ~= 'windsurf' then
  local error_msg = string.format('Invalid value for NVIM_AUTOCOMPLETE: %s. Expected "copilot" or "windsurf". Defaulting to "%s".', M.backend, default)
  vim.notify(error_msg, 'warn')
  M.backend = default
end

---@type { backend: 'copilot' | 'windsurf' }
return M
