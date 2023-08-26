vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = {"*.rs", "*.dart", "*.ts", "*.js"},
    callback = function (ev)
        vim.lsp.buf.format()
    end,
})
