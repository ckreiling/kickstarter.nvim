---@type LazyPluginSpec
return {
  'Exafunction/windsurf.vim',

  event = 'BufEnter',

  cond = function()
    return not vim.g.vsode and not vim.g.sops_engaged
  end,

  config = function()
    vim.g.codeium_disable_bindings = 1 -- for custom bindings
    vim.g.codeium_enabled = true
    vim.g.codeium_idle_delay = 75

    vim.keymap.set('i', '<C-a>', function()
      return vim.fn['codeium#Accept']()
    end, { expr = true, silent = true })
    vim.keymap.set('i', '<c-u>', function()
      return vim.fn['codeium#CycleCompletions'](1)
    end, { expr = true, silent = true })
    vim.keymap.set('i', '<c-d>', function()
      return vim.fn['codeium#CycleCompletions'](-1)
    end, { expr = true, silent = true })
    vim.keymap.set('i', '<c-x>', function()
      return vim.fn['codeium#Clear']()
    end, { expr = true, silent = true })
  end,
}
