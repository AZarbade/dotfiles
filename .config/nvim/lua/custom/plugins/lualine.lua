return {
  'nvim-lualine/lualine.nvim',
  config = function()
    require('lualine').setup {
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      disabled_filetypes = { 'packer', 'NvimTree' },
      options = {
        theme = 'catppuccin',
      },
    }
  end,
}
