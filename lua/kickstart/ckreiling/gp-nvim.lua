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

local function keymapOptions(desc)
  return {
    noremap = true,
    silent = true,
    nowait = true,
    desc = 'GPT ' .. desc,
  }
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

      -- Chat commands
      vim.keymap.set({ 'n', 'i' }, '<C-g>c', '<cmd>GpChatNew<cr>', keymapOptions 'New Chat')
      vim.keymap.set({ 'n', 'i' }, '<C-g>t', '<cmd>GpChatToggle<cr>', keymapOptions 'Toggle Chat')
      vim.keymap.set({ 'n', 'i' }, '<C-g>f', '<cmd>GpChatFinder<cr>', keymapOptions 'Chat Finder')

      vim.keymap.set('v', '<C-g>c', ":<C-u>'<,'>GpChatNew<cr>", keymapOptions 'Visual Chat New')
      vim.keymap.set('v', '<C-g>p', ":<C-u>'<,'>GpChatPaste<cr>", keymapOptions 'Visual Chat Paste')
      vim.keymap.set('v', '<C-g>t', ":<C-u>'<,'>GpChatToggle<cr>", keymapOptions 'Visual Toggle Chat')

      vim.keymap.set({ 'n', 'i' }, '<C-g><C-x>', '<cmd>GpChatNew split<cr>', keymapOptions 'New Chat split')
      vim.keymap.set({ 'n', 'i' }, '<C-g><C-v>', '<cmd>GpChatNew vsplit<cr>', keymapOptions 'New Chat vsplit')
      vim.keymap.set({ 'n', 'i' }, '<C-g><C-t>', '<cmd>GpChatNew tabnew<cr>', keymapOptions 'New Chat tabnew')

      vim.keymap.set('v', '<C-g><C-x>', ":<C-u>'<,'>GpChatNew split<cr>", keymapOptions 'Visual Chat New split')
      vim.keymap.set('v', '<C-g><C-v>', ":<C-u>'<,'>GpChatNew vsplit<cr>", keymapOptions 'Visual Chat New vsplit')
      vim.keymap.set('v', '<C-g><C-t>', ":<C-u>'<,'>GpChatNew tabnew<cr>", keymapOptions 'Visual Chat New tabnew')

      -- Prompt commands
      vim.keymap.set({ 'n', 'i' }, '<C-g>r', '<cmd>GpRewrite<cr>', keymapOptions 'Inline Rewrite')
      vim.keymap.set({ 'n', 'i' }, '<C-g>a', '<cmd>GpAppend<cr>', keymapOptions 'Append (after)')
      vim.keymap.set({ 'n', 'i' }, '<C-g>b', '<cmd>GpPrepend<cr>', keymapOptions 'Prepend (before)')

      vim.keymap.set('v', '<C-g>r', ":<C-u>'<,'>GpRewrite<cr>", keymapOptions 'Visual Rewrite')
      vim.keymap.set('v', '<C-g>a', ":<C-u>'<,'>GpAppend<cr>", keymapOptions 'Visual Append (after)')
      vim.keymap.set('v', '<C-g>b', ":<C-u>'<,'>GpPrepend<cr>", keymapOptions 'Visual Prepend (before)')
      vim.keymap.set('v', '<C-g>i', ":<C-u>'<,'>GpImplement<cr>", keymapOptions 'Implement selection')

      vim.keymap.set({ 'n', 'i' }, '<C-g>gp', '<cmd>GpPopup<cr>', keymapOptions 'Popup')
      vim.keymap.set({ 'n', 'i' }, '<C-g>ge', '<cmd>GpEnew<cr>', keymapOptions 'GpEnew')
      vim.keymap.set({ 'n', 'i' }, '<C-g>gn', '<cmd>GpNew<cr>', keymapOptions 'GpNew')
      vim.keymap.set({ 'n', 'i' }, '<C-g>gv', '<cmd>GpVnew<cr>', keymapOptions 'GpVnew')
      vim.keymap.set({ 'n', 'i' }, '<C-g>gt', '<cmd>GpTabnew<cr>', keymapOptions 'GpTabnew')

      vim.keymap.set('v', '<C-g>gp', ":<C-u>'<,'>GpPopup<cr>", keymapOptions 'Visual Popup')
      vim.keymap.set('v', '<C-g>ge', ":<C-u>'<,'>GpEnew<cr>", keymapOptions 'Visual GpEnew')
      vim.keymap.set('v', '<C-g>gn', ":<C-u>'<,'>GpNew<cr>", keymapOptions 'Visual GpNew')
      vim.keymap.set('v', '<C-g>gv', ":<C-u>'<,'>GpVnew<cr>", keymapOptions 'Visual GpVnew')
      vim.keymap.set('v', '<C-g>gt', ":<C-u>'<,'>GpTabnew<cr>", keymapOptions 'Visual GpTabnew')

      vim.keymap.set({ 'n', 'i' }, '<C-g>x', '<cmd>GpContext<cr>', keymapOptions 'Toggle Context')
      vim.keymap.set('v', '<C-g>x', ":<C-u>'<,'>GpContext<cr>", keymapOptions 'Visual Toggle Context')

      vim.keymap.set({ 'n', 'i', 'v', 'x' }, '<C-g>s', '<cmd>GpStop<cr>', keymapOptions 'Stop')
      vim.keymap.set({ 'n', 'i', 'v', 'x' }, '<C-g>n', '<cmd>GpNextAgent<cr>', keymapOptions 'Next Agent')
    end,
  }
end
