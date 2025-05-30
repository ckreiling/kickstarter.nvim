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
        diagnostics = 'nvim_lsp',
        diagnostics_indicator = function(count, level)
          local icon = level:match 'error' and ' ' or ' '
          return ' ' .. icon .. count
        end,
        show_close_icon = true,
        show_buffer_close_icons = true,
      },
    }

    -- Keybindings for buffer navigation
    vim.api.nvim_set_keymap('n', '<Tab>', ':BufferLineCycleNext<CR>', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<S-Tab>', ':BufferLineCyclePrev<CR>', { noremap = true, silent = true })
  end,
}
