local map = vim.keymap.set

--  Use CTRL+<hjkl> to switch between windows
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Move selected line / block of text in visual mode
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { noremap = true, desc = "Move selected text down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { noremap = true, desc = "Move selected text up" })

-- paste over currently selected text without yanking it
map("v", "p", '"_dp', { desc = "Paste over selection without yanking" })

-- Fast saving and quitting
map("n", "<Leader>w", ":write!<CR>", { noremap = true, desc = "Save file" })

-- Remap for dealing with visual line wraps
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Move up (including wrapped lines)" })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Move down (including wrapped lines)" })

-- Better indenting
map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Navigate buffers
map("n", "<Right>", ":bnext<CR>", { noremap = true, desc = "Go to next buffer" })
map("n", "<Left>", ":bprevious<CR>", { noremap = true, desc = "Go to previous buffer" })

-- Select all
map("n", "<C-a>", "ggVG", { noremap = true, desc = "Select all text" })

-- Clear search highlighting
map("n", "<Esc>", ":nohlsearch<CR>", { noremap = true, desc = "Clear search highlighting" })

-- Substitution
map("n", "<C-s>", ":%s/\\<<C-r><C-w>\\>//g<left><left>", { noremap = true, desc = "Substitute current word" })
