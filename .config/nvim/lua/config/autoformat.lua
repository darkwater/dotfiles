vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = {"*.rs", "*.dart"},
    callback = function (ev)
        vim.lsp.buf.format()
    end,
})
