local function lookup(table, key, default)
  return table[key] ~= nil and table[key] or default
end

return function(config)
  local disable_anthropic = lookup(config, 'disable_anthropic', false)
  local disable_copilot = lookup(config, 'disable_copilot', false)
  local anthropic_model = lookup(config, 'anthropic_model', 'claude-3-5-sonnet-20240620')
  local copilot_model = lookup(config, 'copilot_model', 'gpt-4')

  return {
    'robitx/gp.nvim',
    config = function()
      local conf = {
        openai_api_key = 'bogus', -- must be set to avoid errors
        providers = {
          openai = {
            disable = true,
          },
          anthropic = {
            disable = disable_anthropic,
            endpoint = 'https://api.anthropic.com/v1/messages',
            secret = os.getenv 'ANTHROPIC_API_KEY',
          },
          copilot = {
            disable = disable_copilot,
            endpoint = 'https://api.githubcopilot.com/chat/completions',
            secret = {
              'bash',
              '-c',
              'jq -r \'.["github.com"].oauth_token\' ~/.config/github-copilot/hosts.json',
            },
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
