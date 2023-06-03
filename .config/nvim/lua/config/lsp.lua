local lsp = require("lspconfig")

vim.diagnostic.config {
    virtual_text = true,
    severity_sort = true,
    float = { source = "if_many" },
}

lsp.rust_analyzer.setup {
    settings = {
        ["rust-analyzer"] = {
            checkOnSave = {
                command = "clippy",
            },
            cargo = {
                loadOutDirsFromCheck = true,
            },
            procMacro = {
                enable = true,
            },
        },
    }
}
