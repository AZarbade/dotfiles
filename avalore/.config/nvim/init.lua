-------------------------------------------------------------------------------
--
-- options
--
-------------------------------------------------------------------------------
-- always set leader first!
vim.g.mapleader = " "

-- main colorscheme
vim.opt.termguicolors = true
vim.cmd("colorscheme retrobox")

local function set_transparent() -- set UI component to transparent
    local groups = {
        "Normal",
        "NormalNC",
        "EndOfBuffer",
        "NormalFloat",
        "FloatBorder",
        "SignColumn",
        "StatusLine",
        "StatusLineNC",
        "TabLine",
        "TabLineFill",
        "TabLineSel",
        "ColorColumn",
    }
    for _, g in ipairs(groups) do
        vim.api.nvim_set_hl(0, g, { bg = "none" })
    end
end

set_transparent()

vim.opt.wrap = false
vim.opt.signcolumn = 'yes'
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.scrolloff = 10
-- infinite undo!
-- NOTE: ends up in ~/.local/state/nvim/undo/
vim.opt.undofile = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.diffopt:append('iwhite')
vim.opt.diffopt:append('algorithm:histogram')
vim.opt.diffopt:append('indent-heuristic')
vim.opt.showmode = false
vim.opt.conceallevel = 2
vim.opt.concealcursor = "n"
vim.opt.clipboard:append("unnamedplus")

-------------------------------------------------------------------------------
--
-- statusline
--
-------------------------------------------------------------------------------
-- File type with Nerd Font icon
local function file_type()
    local ft = vim.bo.filetype
    local icons = {
        lua = "\u{e620} ",      -- nf-dev-lua
        python = "\u{e73c} ",   -- nf-dev-python
        markdown = "\u{e73e} ", -- nf-dev-markdown
        sh = "\u{f489} ",       -- nf-oct-terminal
        rust = "\u{e7a8} ",     -- nf-dev-rust
        c = "\u{e61e} ",        -- nf-dev-c
    }

    return ((icons[ft] or " \u{f15b} ") .. ft)
end

-- Mode indicators with Nerd Font icons
local function mode_icon()
    local mode = vim.fn.mode()
    local modes = {
        n = " \u{f121}  NORMAL",
        i = " \u{f11c}  INSERT",
        v = " \u{f0168} VISUAL",
        V = " \u{f0168} V-LINE",
        ["\22"] = " \u{f0168} V-BLOCK",
        c = " \u{f120} COMMAND",
        s = " \u{f0c5} SELECT",
        S = " \u{f0c5} S-LINE",
        ["\19"] = " \u{f0c5} S-BLOCK",
        R = " \u{f044} REPLACE",
        r = " \u{f044} REPLACE",
        ["!"] = " \u{f489} SHELL",
        t = " \u{f120} TERMINAL",
    }
    return modes[mode] or (" \u{f059} " .. mode)
end

_G.mode_icon = mode_icon
_G.file_type = file_type

vim.api.nvim_set_hl(0, "StatusLineBold", { bold = true })

-- Function to change statusline based on window focus
local function setup_dynamic_statusline()
    vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
        callback = function()
            vim.opt_local.statusline = table.concat({
                "  ",
                "%#StatusLineBold#",
                "%{v:lua.mode_icon()}",
                "%#StatusLine#",
                " \u{f444} %f %h%m%r",
                "%=",
                "%{v:lua.file_type()}",
            })
        end,
    })

    vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
        callback = function()
            vim.opt_local.statusline = "  %f %h%m%r \u{e0b1} %{v:lua.file_type()} %=  %l:%c   %P "
        end,
    })
end

setup_dynamic_statusline()

-------------------------------------------------------------------------------
--
-- keybinds
--
-------------------------------------------------------------------------------
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
-- better cut/paste
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })
vim.keymap.set({ "n", "v" }, "<leader>x", '"_d', { desc = "Delete without yanking" })

-- file picker using fzf
vim.keymap.set('n', '<C-p>', function()
    local temp = vim.fn.tempname()
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

-- toggle diagnostics
vim.keymap.set('n', '<leader>td', function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = 'Toggle diagnostics' })

-------------------------------------------------------------------------------
--
-- configuring diagnostics
--
-------------------------------------------------------------------------------
vim.diagnostic.config({
    virtual_text = {
        spacing = 8,
        prefix = '●',
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

-- stops auto-completion to fill the first choice automatically
vim.opt.completeopt = { 'menuone', 'noselect', 'noinsert' }

-- LSP keymaps
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        vim.lsp.completion.enable(true, args.data.client_id, args.buf, {
            autotrigger = true,
        })

        local map = function(keys, fn, desc)
            vim.keymap.set('n', keys, fn, { buffer = args.buf, desc = desc })
        end

        map('K', function() vim.lsp.buf.hover({ border = 'rounded' }) end, 'Hover docs')
        map('gd', vim.lsp.buf.definition, 'Go to definition')
        map('gD', vim.lsp.buf.declaration, 'Go to declaration')
        map('gi', vim.lsp.buf.implementation, 'Go to implementation')
        map('gr', vim.lsp.buf.references, 'Find references')
        map('<leader>r', vim.lsp.buf.rename, 'Rename symbol')
        map('<leader>ca', vim.lsp.buf.code_action, 'Code action')
        map('[d', function() vim.diagnostic.jump({ count = -1 }) end, 'Prev diagnostic')
        map(']d', function() vim.diagnostic.jump({ count = 1 }) end, 'Next diagnostic')
    end,
})

-------------------------------------------------------------------------------
--
-- plugin configurations
--
-------------------------------------------------------------------------------
vim.pack.add({
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = 'https://github.com/stevearc/oil.nvim' },
})

-- lsp settings
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
    'rust_analyzer', -- Rust
    'ruff',          -- Python
    'clangd',        -- C lang
    'lua_ls',        -- Lua
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
