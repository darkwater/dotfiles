require('crates').setup {}
require("rust-tools").setup {
    tools = {
        executor = require("rust-tools.executors").quickfix,
        inlay_hints = {
        },
    },
    server = {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        settings = {
            ["rust-analyzer"] = {
                assist = {
                    importMergeBehavior = "last",
                    importPrefix = "by_self",
                },
                cargo = {
                    loadOutDirsFromCheck = true,
                },
                checkOnSave = {
                    command = "clippy",
                },
                completion = {
                    postfix = {
                        enable = false,
                    },
                },
                diagnostics = {
                    enable = true,
                    disabled = {
                        -- "unresolved-proc-macro",
                        "inactive-code",
                    },
                },
                procMacro = {
                    enable = true,
                },
            },
        },
    },
}
