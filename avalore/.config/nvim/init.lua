-- always set leader first!
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "

vim.opt.scrolloff = 10
vim.opt.wrap = false
vim.opt.signcolumn = 'yes'
vim.opt.relativenumber = true
vim.opt.number = true
-- infinite undo!
-- NOTE: ends up in ~/.local/state/nvim/undo/
vim.opt.undofile = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.expandtab = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.diffopt:append('iwhite')
vim.opt.diffopt:append('algorithm:histogram')
vim.opt.diffopt:append('indent-heuristic')

-- main colorscheme
vim.cmd("colorscheme retrobox")

-- Remove background everywhere
vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
vim.api.nvim_set_hl(0, "LineNr", { bg = "NONE" })
vim.api.nvim_set_hl(0, "CursorLine", { bg = "NONE" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE" })

-------------------------------------------------------------------------------
--
-- hotkeys
--
-------------------------------------------------------------------------------
-- let the left and right arrows be useful: they can switch buffers
vim.keymap.set('n', '<left>', ':bp<cr>')
vim.keymap.set('n', '<right>', ':bn<cr>')
-- copy to clipboard
vim.keymap.set({ "n", "v", "o" }, "<leader>y", '"+y')
-- move across nvim panes
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left pane' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to bottom pane' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to top pane' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right pane' })
-- file picker using fzf
vim.keymap.set('n', '<C-p>', function()
    local temp = os.tmpname()
    vim.cmd('new') 
    vim.fn.termopen('fzf > ' .. temp, {
        on_exit = function()
            vim.cmd('bdelete!')
            local f = io.open(temp, 'r')
            if f then
                local file = f:read('*all'):gsub('\n', '')
                f:close()
                os.remove(temp)
                if file ~= '' then
                    vim.cmd('edit ' .. file)
                end
            end
        end
    })
    vim.cmd('startinsert')
end, { desc = 'fzf file picker' })

-------------------------------------------------------------------------------
--
-- configuring diagnostics
--
-------------------------------------------------------------------------------
-- Allow virtual text
vim.diagnostic.config({
  signs = true,
  underline = true,
  severity_sort = true,
  virtual_lines = false,
  virtual_text = {
    spacing = 4,
    source = "if_many",
    prefix = '●', -- A small dot is less distracting than text
    severity = { min = vim.diagnostic.severity.WARN },
  },
  float = {
    focused = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = { "󰒋 Diagnostics", "DiagnosticFloatingHeader" },
    prefix = "",
  },
  update_in_insert = false,
})

-------------------------------------------------------------------------------
--
-- autocommands
--
-------------------------------------------------------------------------------
-- highlight yanked text
vim.api.nvim_create_autocmd(
	'TextYankPost',
	{
		pattern = '*',
		command = 'silent! lua vim.highlight.on_yank({ timeout = 500 })'
	}
)

-- prevent accidental writes to buffers that shouldn't be edited
vim.api.nvim_create_autocmd('BufRead', { pattern = '*.orig', command = 'set readonly' })
vim.api.nvim_create_autocmd('BufRead', { pattern = '*.pacnew', command = 'set readonly' })

-------------------------------------------------------------------------------
--
-- plugin configuration
--
-------------------------------------------------------------------------------
-- first, grab the manager
-- https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
-- then, setup!
require("lazy").setup({
	{ 
		'nvim-mini/mini.nvim',
		version = '*',
		config = function()
			require('mini.completion').setup()
			require('mini.diff').setup()
			vim.keymap.set('n', '<leader>g', MiniDiff.toggle_overlay)
			require('mini.notify').setup({
				window = {
					config = {
						border = 'rounded',
						winhighlight = 'Normal:MiniNotifyNormal',
					},
				},
			})
		end,
	},
	-- LSP
	{
	  'neovim/nvim-lspconfig',
	  config = function()
		vim.lsp.config('rust_analyzer', {
		  settings = {
			['rust-analyzer'] = {
			  cargo = { features = 'all' },
			  check = { command = 'clippy' },
			},
		  },
		})
		vim.lsp.enable({ 'rust_analyzer', 'ruff', 'clangd' })

		vim.api.nvim_create_autocmd('LspAttach', {
		  callback = function(ev)
			vim.api.nvim_create_autocmd('BufWritePre', {
			  buffer = ev.buf,
			  callback = function()
				vim.lsp.buf.format({ bufnr = ev.buf, async = false })
			  end,
			})
		  end,
		})
	  end,
	},
	{
	  'stevearc/oil.nvim',
	  opts = {
		  view_options = {
			  show_hidden = true,
		  },
		  columns = {
			"permissions",
			"size",
			"mtime",
		  },
		  keymaps = {
			["<CR>"] = "actions.select",
			["<C-c>"] = { "actions.close", mode = "n" },
		  },
		  vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
	  },
	  lazy = false,
	},
})
