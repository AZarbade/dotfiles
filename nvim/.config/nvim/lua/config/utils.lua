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

M.compile_c_file = function()
  local filename = vim.fn.expand("%:t")
  local command = string.format("gcc %s -o main -g", filename)

  vim.fn.system(command)

  if vim.v.shell_error == 0 then
    print("Compilation successful!")
  else
    print("Compilation failed. Check for errors.")
  end
end

return M
