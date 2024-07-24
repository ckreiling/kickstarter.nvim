local function lookup(table, key, default)
  return table[key] ~= nil and table[key] or default
end

local function read_and_decode_json(file_path)
  if not vim.fn.filereadable(file_path) then
    return nil
  end

  local ok, contents_list = pcall(vim.fn.readfile, file_path)
  if not ok then
    return nil
  end

  local ok, decoded = pcall(vim.json.decode, table.concat(contents_list, '\n'))
  if not ok then
    return nil
  end

  return decoded
end

return function(config)
  local disable_anthropic = lookup(config, 'disable_anthropic', false)
  local disable_copilot = lookup(config, 'disable_copilot', false)
  local anthropic_model = lookup(config, 'anthropic_model', 'claude-3-5-sonnet-20240620')
  local copilot_model = lookup(config, 'copilot_model', 'gpt-4')

  return {
    'robitx/gp.nvim',
    config = function()
      -- This is so ugly...
      local copilot = { config = nil, secret = nil }
      if not disable_copilot then
        copilot['config'] = read_and_decode_json(os.getenv 'HOME' .. '/.config/github-copilot/hosts.json')
        if copilot['config'] then
          local cfg = copilot['config']
          copilot['secret'] = cfg and cfg['github.com'] and cfg['github.com']['oauth_token'] or nil
          if not copilot['secret'] then
            vim.api.nvim_err_writeln 'Warning: GitHub Copilot secret not found in CoPilot config (will not use Copilot for Gp* commands)'
          end
        else
          vim.api.nvim_err_writeln 'Warning: GitHub Copilot config not found (will not use Copilot for Gp* commands)'
        end
      end

      local anthropic_token = os.getenv 'ANTHROPIC_API_KEY'
      if not disable_anthropic and not anthropic_token then
        vim.api.nvim_err_writeln 'Warning: ANTHROPIC_API_KEY not found (will not use Anthropic for Gp* commands)'
      end

      local conf = {
        openai_api_key = 'bogus', -- must be set to avoid errors
        providers = {
          openai = {
            disable = true,
          },
          anthropic = {
            disable = anthropic_token == nil or disable_anthropic,
            endpoint = 'https://api.anthropic.com/v1/messages',
            secret = anthropic_token or 'unknown',
          },
          copilot = {
            disable = copilot['secret'] == nil or disable_copilot,
            endpoint = 'https://api.githubcopilot.com/chat/completions',
            secret = copilot['secret'] or 'unknown',
          },
        },
        agents = {
          {
            name = 'ChatGPT3-5',
            disable = true,
          },
          {
            disable = disable_anthropic,
            provider = 'anthropic',
            name = 'CodeClaude',
            chat = false,
            command = true,
            model = { model = anthropic_model, temperature = 0.8, top_p = 1 },
            system_prompt = require('gp.defaults').code_system_prompt,
          },
          {
            disable = disable_anthropic,
            provider = 'anthropic',
            name = 'ChatClaude',
            chat = true,
            command = false,
            model = { model = anthropic_model, temperature = 0.8, top_p = 1 },
            system_prompt = require('gp.defaults').chat_system_prompt,
          },
          {
            disable = disable_copilot,
            provider = 'copilot',
            name = 'CodeCopilot',
            chat = false,
            command = true,
            model = { model = copilot_model, temperature = 0.8, top_p = 1, n = 1 },
            system_prompt = require('gp.defaults').code_system_prompt,
          },
          {
            disable = disable_copilot,
            provider = 'copilot',
            name = 'ChatCopilot',
            chat = true,
            command = false,
            model = { model = copilot_model, temperature = 1.1, top_p = 1 },
            system_prompt = require('gp.defaults').chat_system_prompt,
          },
        },
      }
      require('gp').setup(conf)
    end,
  }
end
