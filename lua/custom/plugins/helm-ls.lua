---@type LazyPluginSpec
return {
  'qvalentin/helm-ls.nvim',
  ft = 'helm',
  opts = {
    conceal_templates = {
      -- While cool, it's a little annoying since default values don't really matter
      enabled = false,
    },
  },
}
