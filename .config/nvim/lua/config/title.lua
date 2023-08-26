local cwd = vim.fn.getcwd()
local without_home = string.gsub(cwd, os.getenv("HOME") or os.getenv("userprofile"), "~")

vim.opt.titlestring = "nvim " .. without_home
