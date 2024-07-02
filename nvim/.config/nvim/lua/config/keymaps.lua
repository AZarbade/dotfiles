local opts = { noremap = true, silent = true }
local map = vim.keymap.set

-- Keep cursor centered when scrolling
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)

-- Move selected line / block of text in visual mode
map("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
map("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)

-- Cut full line
map("n", "<C-x>", "dd", opts)

-- Fast saving and quitting
map("n", "<Leader>w", ":write!<CR>", opts)
map("n", "<Leader>q", ":q!<CR>", opts)

-- Remap for dealing with visual line wraps
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Navigate buffers
map("n", "<Right>", ":bnext<CR>", opts)
map("n", "<Left>", ":bprevious<CR>", opts)

-- Keep search results centered
map("n", "n", "nzzv", opts)
map("n", "N", "Nzzv", opts)
map("n", "*", "*zzv", opts)
map("n", "#", "#zzv", opts)

-- Select all
map("n", "<C-a>", "ggVG", opts)

-- Clear search highlighting
map("n", "<Esc>", ":nohlsearch<CR>", opts)

-- Toggle Go test
map("n", "<C-P>", ':lua require("config.utils").toggle_go_test()<CR>', opts)
