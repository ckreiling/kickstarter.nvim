---@type LazyPluginSpec
return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    vim.opt.termguicolors = true
    ---@type bufferline.Config
    require('bufferline').setup {
      options = {
        separator_style = 'slant',
      },
    }
  end,
}
