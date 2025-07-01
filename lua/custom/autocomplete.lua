local M = {}

-- Change this to edit the default autocomplete plugin
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
