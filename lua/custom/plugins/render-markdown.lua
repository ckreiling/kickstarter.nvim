---@type LazyPluginSpec
return {
  'MeanderingProgrammer/render-markdown.nvim',
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    file_types = { 'markdown', 'Avante', 'codecompanion' },
  },
  ft = { 'markdown', 'codecompanion', 'Avante' },
}
