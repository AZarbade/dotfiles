return {
  {
    "cmc.nvim",
    lazy = true,
    ft = "c",
    dir = "~/personal/neovim_plugins/cmc.nvim",
    opts = {
      output_name = "main", -- default output name
      ask_output_name = false, -- set to true to prompt for name each time
      -- default_flags = "", -- add default arguments to pass to compiler
    },
    config = function(_, opts)
      require("cmc.config").setup(opts)
    end,
  },
}
