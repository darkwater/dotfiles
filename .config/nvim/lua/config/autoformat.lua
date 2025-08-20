vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = {"*.rs", "*.dart", "*.ts", "*.js", "*.tsx", "*.jsx", "*.cs"},
    callback = function (ev)
        -- Check if formatting is supported by any attached client
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        for _, client in ipairs(clients) do
            if client.supports_method("textDocument/formatting") then
                vim.lsp.buf.format({ async = false })
                break
            end
        end
    end,
})
