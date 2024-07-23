local copilot_model = 'gpt-4'

return {
  'robitx/gp.nvim',
  config = function()
    local conf = {
      openai_api_key = 'bogus',
      providers = {
        openai = {
          disable = true,
        },
        copilot = {
          disable = false,
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
          provider = 'copilot',
          name = 'CodeCopilot',
          chat = false,
          command = true,
          -- string with the Copilot engine name or table with engine name and parameters if applicable
          model = { model = copilot_model, temperature = 0.8, top_p = 1, n = 1 },
          -- system prompt (use this to specify the persona/role of the AI)
          system_prompt = require('gp.defaults').code_system_prompt,
        },
        {
          provider = 'copilot',
          name = 'ChatCopilot',
          chat = true,
          command = false,
          -- string with model name or table with model name and parameters
          model = { model = copilot_model, temperature = 1.1, top_p = 1 },
          -- system prompt (use this to specify the persona/role of the AI)
          system_prompt = require('gp.defaults').chat_system_prompt,
        },
      },
    }
    require('gp').setup(conf)
  end,
}
