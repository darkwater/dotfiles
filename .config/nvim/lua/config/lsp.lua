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
            checkOnSave = {
                command = "clippy",
            },
            check = {
                command = "clippy",
            },
            completion = {
                postfix = {
                    enable = false,
                },
            },
            linkedProjects = {},
            procMacro = {
                enable = true,
            },
        },
    },
    on_init = function(client)
        local path = client.workspace_folders[1].name
        local config = client.config.settings["rust-analyzer"]

        if path == "/Users/dark/gitea/comforest/firmware" then
            config.linkedProjects = {
                "Cargo.toml",
                "cross/sensor/Cargo.toml",
                "cross/hub/Cargo.toml",
                "cross/powerbox/Cargo.toml",
                "cross/bootloader/Cargo.toml",
            }
        end

        client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
        return true
    end,
}
