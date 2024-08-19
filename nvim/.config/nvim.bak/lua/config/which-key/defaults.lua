return {
  -- General mappings
  mode = { "n", "v" },
  o = { require("telescope.builtin").buffers, "Open Buffer" },
  W = { "<cmd>noautocmd w<cr>", "Save without formatting (noautocmd)" },
  v = { "Go to definition in a split" },
}
