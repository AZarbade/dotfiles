return {
  'stevearc/conform.nvim',
  opts = {},
  init = function()
    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black" },
        rust = { "rustfmt" },
        c = { "clangd" },
      },
      format_on_save = {
        lsp_format = "fallback",
      }
    })
  end
}
