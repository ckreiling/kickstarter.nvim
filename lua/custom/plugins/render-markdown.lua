---@type LazyPluginSpec
return {
  'MeanderingProgrammer/render-markdown.nvim',
  ---@type render.md.UserConfig
  opts = {
    file_types = { 'markdown', 'Avante', 'codecompanion' },
    heading = {
      position = 'overlay',
      left_pad = 1,
      right_pad = 1,
    },
  },
  ft = { 'markdown', 'codecompanion', 'Avante' },
}
