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
        { "<leader>G", group = "Git" },
        { "<leader>l", group = "LSP" },
        { "<leader>d", group = "DAP" },
        { "<leader>c", group = "Compiler" },
        { "<leader>s", group = "Search" },
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
