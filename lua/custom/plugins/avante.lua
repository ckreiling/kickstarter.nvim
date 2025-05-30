return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  version = false,
  opts = {
    provider = 'copilot',
    system_prompt = function()
      local hub = require('mcphub').get_hub_instance()
      return hub and hub:get_active_servers_prompt() or ''
    end,
    custom_tools = function()
      return {
        require('mcphub.extensions.avante').mcp_tool(),
      }
    end,
    disabled_tools = {
      -- 'rag_search',
      -- 'python',
      -- 'git_diff',
      -- 'git_commit',
      -- 'list_files',
      -- 'search_files',
      -- 'search_keyword',
      -- 'read_file_toplevel_symbols',
      -- 'read_file',
      -- 'create_file',
      -- 'rename_file',
      -- 'delete_file',
      -- 'create_dir',
      -- 'rename_dir',
      -- 'delete_dir',
      -- 'bash',
      'web_search',
      'fetch',
    },
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = 'make',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',

    --- The below dependencies are optional,
    'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
    'hrsh7th/nvim-cmp',
    'zbirenbaum/copilot.lua', -- for providers='copilot'
    'MeanderingProgrammer/render-markdown.nvim',
  },
}
