local M = {}

-- Change this to edit the default autocomplete plugin
local default = 'copilot'
M.backend = os.getenv 'NVIM_AUTOCOMPLETE' or default

if M.backend ~= 'copilot' and M.backend ~= 'windsurf' then
  local error_msg = string.format('Invalid value for NVIM_AUTOCOMPLETE: %s. Expected "copilot" or "windsurf". Defaulting to "copilot".', M.backend)
  vim.notify(error_msg, 'warn')
end

---@type { backend: 'copilot' | 'windsurf' }
return M
