return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    icons = {
      mappings = false,
    },

    win = {
      border = "single", -- none, single, double, shadow
      title = false,
    },
    spec = {
      {
        mode = { "n", "v" },
        { "<leader>s", group = "Search" },
        { "<leader>d", group = "DAP" },
        { "<leader>l", group = "LSP" },
        { "<leader>G", group = "Git" },
        { "<leader>c", group = "Compiler" },
        { "<leader>x", group = "diagnostics/quickfix" },
      },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
