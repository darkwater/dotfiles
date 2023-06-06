local cwd = vim.fn.getcwd()
local without_home = string.gsub(cwd, os.getenv("HOME"), "~")

vim.opt.titlestring = "nvim " .. without_home
