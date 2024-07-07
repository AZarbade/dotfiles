return {
  {
    "AZarbade/cmc.nvim",
    -- dir = "~/personal/neovim_plugins/cmc.nvim",
    -- dev = true,
    opts = {},
    config = function(_, opts)
      require("cmc.config").setup(opts)
    end,
  },
}
