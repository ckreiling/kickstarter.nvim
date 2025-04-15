---@type LazyPluginSpec
return {
  'stevearc/dressing.nvim',
  opts = {},
  cond = function()
    return not vim.g.vscode
  end,
}
