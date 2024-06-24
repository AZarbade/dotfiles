return {
  'epwalsh/obsidian.nvim',
  version = '*',
  lazy = true,
  ft = 'markdown',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  opts = {
    workspaces = {
      {
        name = 'avalore',
        path = '~/personal/avalore/',
      },
    },
    disable_frontmatter = true,
    notes_subdir = 'inbox',
    new_notes_location = 'notes_subdir',
    templates = {
      subdir = 'templates',
      date_format = '%d-%m-%Y',
      time_format = '%H:%M:%S',
    },
    mappings = {
      -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
      ['gf'] = {
        action = function()
          return require('obsidian').util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      -- Toggle check-boxes.
      ['<leader>ch'] = {
        action = function()
          return require('obsidian').util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
      -- NOTE: more keymaps are in keymaps.lua
    },
  },
}
