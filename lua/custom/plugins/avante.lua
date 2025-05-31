---@type LazyPluginSpec
return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  version = false,
  config = function()
    -- There is an Avante bug where it tries to read the current buffer from the
    -- git root, instead of the current working directory according to Neovim.
    -- Admittedly this is blindly pasted from a GitHub issue, but it seems to
    -- work: https://github.com/yetone/avante.nvim/issues/2046#issuecomment-2905410720
    vim.g.root_spec = { { '.git' }, 'lsp', 'cwd' }

    require('avante').setup {
      provider = os.getenv 'ANTHROPIC_API_KEY' and 'claude' or 'copilot',
      system_prompt = function()
        local hub = require('mcphub').get_hub_instance()
        return hub and hub:get_active_servers_prompt() or ''
      end,
      claude = {
        model = os.getenv 'ANTHROPIC_MODEL' or 'claude-3-7-sonnet-20250219',
      },
      copilot = {
        model = os.getenv 'COPILOT_MODEL' or 'gpt-4.1-2025-04-14',
      },
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
    }
  end,
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
    'ravitemer/mcphub.nvim',
  },
}
