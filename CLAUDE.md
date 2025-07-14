# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a personal fork of kickstart.nvim - a minimal, well-documented Neovim configuration that serves as a starting point rather than a full distribution. The configuration follows a hybrid approach:

- **Core configuration**: Single-file setup in `init.lua` (kickstart.nvim pattern)
- **Custom plugins**: Modular plugins in `lua/custom/plugins/` directory
- **Dynamic autocomplete**: Configurable backend system (Copilot vs Windsurf)

## Key Configuration Files

- `init.lua`: Main configuration file containing all core settings, keymaps, and plugin specifications
- `lua/custom/autocomplete.lua`: Autocomplete backend configuration system
- `lua/custom/plugins/*.lua`: Custom plugin specifications loaded via lazy.nvim

## Plugin Management

Uses lazy.nvim for plugin management with automatic installation. Core plugins are defined in `init.lua`, while custom plugins are in `lua/custom/plugins/`.

Key plugins include:
- **LSP**: Full LSP setup with mason.nvim for automatic tool installation
- **Telescope**: Fuzzy finder with extensive keymaps
- **Treesitter**: Syntax highlighting and parsing
- **Autocompletion**: nvim-cmp with dynamic backend switching
- **AI Assistance**: Claude Code integration with comprehensive keymaps

## Autocomplete System

The configuration uses a dynamic autocomplete backend system:

- Backend controlled by `NVIM_AUTOCOMPLETE` environment variable or `lua/custom/autocomplete.lua:5`
- Supports 'copilot' and 'windsurf' backends
- Only one backend is active at a time based on configuration
- Both backends use consistent keymaps: `<C-a>` (accept), `<C-u>` (next), `<C-d>` (previous)

## Key Mappings

**Leader key**: `<space>`

**Core navigation**:
- `<C-p>`: Find files (Telescope)
- `<leader>sg`: Live grep search
- `<leader>sh`: Search help
- `<leader><leader>`: Switch buffers

**LSP**:
- `gd`: Go to definition
- `gr`: Go to references  
- `K`: Hover documentation
- `<leader>ca`: Code actions
- `<leader>rn`: Rename symbol

**Claude Code** (AI integration):
- `<leader>ac`: Toggle Claude
- `<leader>af`: Focus Claude
- `<leader>ar`: Resume Claude session
- `<leader>ab`: Add current buffer to Claude
- `<leader>as`: Send selection to Claude (visual mode)
- `<leader>aa`: Accept Claude diff
- `<leader>ad`: Deny Claude diff

## Language Support

Extensive LSP support configured for:
- Lua (lua_ls)
- TypeScript/JavaScript (ts_ls)
- Python (basedpyright)
- Go (gopls)
- Terraform (terraformls)
- YAML (yamlls with schema support)
- JSON (jsonls with schema validation)
- CSS (cssls)
- Elixir (elixirls)
- OCaml (ocamllsp)
- TOML (taplo)

## Formatting

Uses conform.nvim for formatting with language-specific formatters:
- Lua: stylua
- Python: ruff_format + ruff_fix
- JavaScript/TypeScript: prettier
- Go: goimports + gofmt
- Terraform: terraform fmt

Format on save is enabled for most languages (disabled for C/C++).

## Testing

No specific test framework configured - check project-specific documentation for testing approach.

## Development Workflow

1. Plugin management: Use `:Lazy` to view/update plugins
2. LSP tools: Use `:Mason` to manage language servers and tools
3. Configuration reload: Restart nvim after config changes
4. Health check: Use `:checkhealth` to diagnose issues

## Custom Plugin Directory

The `lua/custom/plugins/` directory is reserved for personal plugins and will not conflict with upstream kickstart.nvim updates. Each `.lua` file should return a lazy.nvim plugin specification.