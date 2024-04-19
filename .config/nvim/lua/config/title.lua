local function update_title()
    local cwd = vim.fn.getcwd()
    local without_home = string.gsub(cwd, os.getenv("HOME") or os.getenv("userprofile"), "~")

    vim.opt.titlestring = "nvim " .. without_home
end

update_title()

vim.api.nvim_create_autocmd("DirChanged", {
    pattern = "*",
    callback = update_title,
})
