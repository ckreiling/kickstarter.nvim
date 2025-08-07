---@type LazyPluginSpec
return {
  'f-person/auto-dark-mode.nvim',
  priority = 1000,
  opts = {
    set_dark_mode = function()
      vim.cmd.colorscheme 'tokyonight-night'
    end,
    set_light_mode = function()
      vim.cmd.colorscheme 'gruvbox'
    end,
    update_interval = 1000,
    fallback = 'dark',
  },
}
