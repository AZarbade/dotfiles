-------------------------------------------------------------------------------
--
-- options
--
-------------------------------------------------------------------------------
-- always set leader first!
vim.g.mapleader = " "

-- main colorscheme
vim.cmd("colorscheme retrobox")
vim.opt.termguicolors = true

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
    vim.api.nvim_set_hl(0, "TabLineFill", { bg = "none", fg = "#767676" })
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
vim.opt.lazyredraw = true
vim.opt.clipboard:append("unnamedplus")

-------------------------------------------------------------------------------
--
-- statusline
--
-------------------------------------------------------------------------------
-- Git branch function with caching and Nerd Font icon
local cached_branch = ""
local last_check = 0
local function git_branch()
    local now = vim.loop.now()
    if now - last_check > 5000 then -- Check every 5 seconds
        cached_branch = vim.fn.system("git branch --show-current 2>/dev/null | tr -d '\n'")
        last_check = now
    end
    if cached_branch ~= "" then
        return " \u{e725} " .. cached_branch .. " " -- nf-dev-git_branch
    end
    return ""
end

-- File type with Nerd Font icon
local function file_type()
    local ft = vim.bo.filetype
    local icons = {
        lua = "\u{e620} ",  -- nf-dev-lua
        python = "\u{e73c} ", -- nf-dev-python
        javascript = "\u{e74e} ", -- nf-dev-javascript
        typescript = "\u{e628} ", -- nf-dev-typescript
        javascriptreact = "\u{e7ba} ",
        typescriptreact = "\u{e7ba} ",
        html = "\u{e736} ", -- nf-dev-html5
        css = "\u{e749} ", -- nf-dev-css3
        scss = "\u{e749} ",
        json = "\u{e60b} ", -- nf-dev-json
        markdown = "\u{e73e} ", -- nf-dev-markdown
        vim = "\u{e62b} ", -- nf-dev-vim
        sh = "\u{f489} ", -- nf-oct-terminal
        bash = "\u{f489} ",
        zsh = "\u{f489} ",
        rust = "\u{e7a8} ", -- nf-dev-rust
        go = "\u{e724} ", -- nf-dev-go
        c = "\u{e61e} ", -- nf-dev-c
        cpp = "\u{e61d} ", -- nf-dev-cplusplus
        java = "\u{e738} ", -- nf-dev-java
        php = "\u{e73d} ", -- nf-dev-php
        ruby = "\u{e739} ", -- nf-dev-ruby
        swift = "\u{e755} ", -- nf-dev-swift
        kotlin = "\u{e634} ",
        dart = "\u{e798} ",
        elixir = "\u{e62d} ",
        haskell = "\u{e777} ",
        sql = "\u{e706} ",
        yaml = "\u{f481} ",
        toml = "\u{e615} ",
        xml = "\u{f05c} ",
        dockerfile = "\u{f308} ", -- nf-linux-docker
        gitcommit = "\u{f418} ", -- nf-oct-git_commit
        gitconfig = "\u{f1d3} ", -- nf-fa-git
        vue = "\u{fd42} ",  -- nf-md-vuejs
        svelte = "\u{e697} ",
        astro = "\u{e628} ",
    }

    if ft == "" then
        return " \u{f15b} " -- nf-fa-file_o
    end

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
_G.git_branch = git_branch
_G.file_type = file_type

vim.cmd([[
  highlight StatusLineBold gui=bold cterm=bold
]])

-- Function to change statusline based on window focus
local function setup_dynamic_statusline()
    vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
        callback = function()
            vim.opt_local.statusline = table.concat({
                "  ",
                "%#StatusLineBold#",
                "%{v:lua.mode_icon()}",
                "%#StatusLine#",
                " \u{f444} %f %h%m%r", -- nf-pl-left_hard_divider
                "%{v:lua.git_branch()}",
                "\u{f444} ", -- nf-oct-dot_fill
                "%=",      -- Right-align everything after this
                "%{v:lua.file_type()}",
            })
        end,
    })
    vim.api.nvim_set_hl(0, "StatusLineBold", { bold = true })

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
        vim.lsp.completion.enable(true, args.data.client_id, args.buf, {
            autotrigger = true,
        })
        vim.keymap.set('n', 'K', function()
            vim.lsp.buf.hover({ border = 'rounded' })
        end, { buffer = args.buf })
    end,
})

-- stops auto-completion to fill the first choice automatically
vim.opt.completeopt = { 'menuone', 'noselect', 'noinsert' }

-------------------------------------------------------------------------------
--
-- plugin configuration
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
