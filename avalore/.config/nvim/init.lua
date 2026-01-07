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

-------------------------------------------------------------------------------
--
-- hotkeys
--
-------------------------------------------------------------------------------
-- Ctrl+h to stop searching
vim.keymap.set('v', '<C-h>', '<cmd>nohlsearch<cr>')
vim.keymap.set('n', '<C-h>', '<cmd>nohlsearch<cr>')
-- open new file adjacent to current file
vim.keymap.set('n', '<C-o>', ':e <C-R>=expand("%:p:h") . "/" <cr>')
-- let the left and right arrows be useful: they can switch buffers
vim.keymap.set('n', '<left>', ':bp<cr>')
vim.keymap.set('n', '<right>', ':bn<cr>')
-- make j and k move by visual line, not actual line, when text is soft-wrapped
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')
-- copy to clipboard
vim.keymap.set({ "n", "v", "o" }, "<leader>y", '"+y')
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
	-- main color scheme
	{
		"wincent/base16-nvim",
		lazy = false, -- load at start
		priority = 1000, -- load first
		config = function()
			vim.cmd([[colorscheme gruvbox-dark-hard]])
			vim.o.background = NONE
			vim.cmd([[hi Normal ctermbg=NONE guibg=NONE]])
			-- Make comments more prominent (if that's still your goal)
			local bools = vim.api.nvim_get_hl(0, { name = 'Boolean' })
			vim.api.nvim_set_hl(0, 'Comment', bools)
		end
	},
	-- LSP
	{
		'neovim/nvim-lspconfig',
		config = function()
			-- 1. Configure and Enable Servers
			vim.lsp.config('rust_analyzer', {
				settings = {
					['rust-analyzer'] = {
						cargo = { features = 'all' },
						check = { command = 'clippy' },
					},
				},
			})

			-- Enable servers
			vim.lsp.enable({ 'rust_analyzer', 'ruff', 'clangd' })
			vim.lsp.enable('rust_analyzer')

			-- 2. Global Mappings
			vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

			-- 3. Buffer-local Mappings & Format on Save
			vim.api.nvim_create_autocmd('LspAttach', {
				callback = function(ev)
					local opts = { buffer = ev.buf }
					vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
					vim.keymap.set('n', 'K',  vim.lsp.buf.hover, opts)
					vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
					vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
					vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, opts)
					vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, opts)

					-- Format on save
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = ev.buf,
						callback = function() 
							vim.lsp.buf.format({ bufnr = ev.buf, async = false }) 
						end,
					})
				end,
			})
		end
	},
	-- LSP-based code-completion
	{
		"hrsh7th/nvim-cmp",
		-- load cmp on InsertEnter
		event = "InsertEnter",
		-- these dependencies will only be loaded when cmp loads
		-- dependencies are always lazy-loaded unless specified otherwise
		dependencies = {
			'neovim/nvim-lspconfig',
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
		config = function()
			local cmp = require'cmp'
			cmp.setup({
				snippet = {
					-- REQUIRED by nvim-cmp. get rid of it once we can
					expand = function(args)
						vim.snippet.expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					['<C-b>'] = cmp.mapping.scroll_docs(-4),
					['<C-f>'] = cmp.mapping.scroll_docs(4),
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-e>'] = cmp.mapping.abort(),
					-- Accept currently selected item.
					-- Set `select` to `false` to only confirm explicitly selected items.
					['<CR>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }),
				}),
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
				}, {
					{ name = 'path' },
				}),
				experimental = {
					ghost_text = true,
				},
			})

			-- Enable completing paths in :
			cmp.setup.cmdline(':', {
				sources = cmp.config.sources({
					{ name = 'path' }
				})
			})
		end
	},
	-- inline function signatures
	{
		"ray-x/lsp_signature.nvim",
		event = "VeryLazy",
		opts = {},
		config = function(_, opts)
			-- Get signatures (and _only_ signatures) when in argument lists.
			require "lsp_signature".setup({
				doc_lines = 0,
				handler_opts = {
					border = "none"
				},
			})
		end
	},
	-- nvim line inside tmux line
	{
		"vimpostor/vim-tpipeline",
		init = function()
			vim.g.tpipeline_clear_colors = 1
		end,
	},
})
