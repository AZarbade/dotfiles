return {
  -- {
  --   'nvim-orgmode/orgmode',
  --   event = 'VeryLazy',
  --   ft = { 'org' },
  --   config = function()
  --     -- Setup orgmode
  --     require('orgmode').setup {
  --       org_agenda_files = '~/personal/orgfiles/**/*',
  --       org_default_notes_file = '~/personal/orgfiles/refile.org',
  --     }
  --   end,
  -- },
  {
    'chipsenkbeil/org-roam.nvim',
    dependencies = {
      {
        'nvim-orgmode/orgmode',
        tag = '0.3.4',
      },
    },
    config = function()
      require('org-roam').setup {
        directory = '~/personal/orgfiles/roam',
      }
    end,
  },
}
