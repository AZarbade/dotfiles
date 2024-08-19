# Neovim Configuration

My Neovim configuration.

- Tuned for:
  - Rust
  - C/C++
  - Python
- Base config used: [adibhanna/nvim](https://github.com/adibhanna/nvim)

## Known Issues

There is a bug with the clangd LSP server. To fix the issue of multiple offset encodings, follow these steps:

1. Open the configuration file:

```
vi ~/.local/share/nvim/lazy/nvim-lspconfig/lua/lspconfig/server_configurations/clangd.lua
```

2. Change the following code:

```lua
local default_capabilities = {
  textDocument = {
    completion = {
      editsNearCursor = true,
    },
  },
  offsetEncoding = { 'utf-8', 'utf-16' }, -- Change this line
}
```

to

```lua
local default_capabilities = {
  textDocument = {
    completion = {
      editsNearCursor = true,
    },
  },
  offsetEncoding = { 'utf-16' }, -- To this
}
```

This change sets the offsetEncoding for clangd to utf-16, which should resolve the warning:  
`"warning: multiple different client offset_encodings detected for buffer, this is not supported yet"`

**Important**: Modifying this file directly may lead to conflicts or errors when updating the nvim-lspconfig plugin. Consider finding a way to override these settings in your local configuration instead of editing the plugin files directly.
