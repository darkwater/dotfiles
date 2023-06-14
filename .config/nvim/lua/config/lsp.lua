local lsp = require("lspconfig")

vim.diagnostic.config {
    virtual_text = true,
    severity_sort = true,
    float = { source = "if_many" },
}

lsp.rust_analyzer.setup {
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                loadOutDirsFromCheck = true,
            },
            check = {
                command = "clippy",
            },
            completion = {
                postfix = {
                    enable = false,
                },
            },
            procMacro = {
                enable = true,
            },
        },
    },
}
