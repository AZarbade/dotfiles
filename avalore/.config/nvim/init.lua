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
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#555555", bg = "NONE" })
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
vim.keymap.set({ 'n', 'v', 'o' }, "<leader>y", '"+y')
-- closes current buffer
vim.keymap.set('n', 'Q', ':bd<CR>', { silent = true })
-- quickly switch to previous buffer
vim.keymap.set('n', '<leader><leader>', ':b#<CR>', { silent = true })
-- move across nvim panes
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left pane' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to bottom pane' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to top pane' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right pane' })
-- search and repalce current word
vim.keymap.set('n', "<C-s>", [[:%s/\<<C-r><C-w>\>//g<Left><Left>]])
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
-- disable virtual text
vim.diagnostic.config({
	virtual_text = {
		spacing = 4,
		prefix = '·',
		source = 'if_many',
	},
	signs = false,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = 'rounded',
		source = 'if_many',
		header = '',
		prefix = '',
	},
})

-- open diagnostics
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)

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

-- rounded boarders to information floats
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(args)
		vim.keymap.set('n', 'K', function()
			vim.lsp.buf.hover({ border = 'rounded' })
		end, { buffer = args.buf })
	end,
})

-------------------------------------------------------------------------------
--
-- plugin configuration
--
-------------------------------------------------------------------------------
vim.pack.add({
	{ src = 'https://github.com/neovim/nvim-lspconfig' },
	{ src = 'https://github.com/stevearc/oil.nvim' },
})

-- lsp enables
vim.lsp.config('rust_analyzer', {
	workspace_required = true,
	settings = {
		['rust-analyzer'] = {
			cargo = { allFeatures = true },
			check = { command = 'clippy' },
		},
	},
})

vim.lsp.enable({
	'rust_analyzer',
	'ruff',
	'clangd',
	'lua_ls',
})

vim.keymap.set({ 'n', 'v' }, '<leader>f', vim.lsp.buf.format)

-- oil.nvim
require("oil").setup({
	view_options = {
		show_hidden = true,
	},
	columns = {
		"permissions",
		"size",
		"mtime",
	},
})

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
