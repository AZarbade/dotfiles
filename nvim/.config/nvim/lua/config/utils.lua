local M = {}

M.telescope_git_or_file = function()
  local path = vim.fn.expand("%:p:h")
  local git_dir = vim.fn.finddir(".git", path .. ";")
if #git_dir > 0 then
    require("telescope.builtin").git_files()
  else
    require("telescope.builtin").find_files()
  end
end

M.toggle_set_color_column = function()
  if vim.wo.colorcolumn == "" then
    vim.wo.colorcolumn = "80"
  else
    vim.wo.colorcolumn = ""
  end
end

M.toggle_cursor_line = function()
  if vim.wo.cursorline then
    vim.wo.cursorline = false
  else
    vim.wo.cursorline = true
  end
end

return M
