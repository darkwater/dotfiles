vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = {"*.rs", "*.dart", "*.ts", "*.js"},
    callback = function (ev)
        -- Check if formatting is supported by any attached client
        local clients = vim.lsp.get_active_clients({ bufnr = 0 })
        for _, client in ipairs(clients) do
            if client.supports_method("textDocument/formatting") then
                vim.lsp.buf.format()
                break
            end
        end
    end,
})
