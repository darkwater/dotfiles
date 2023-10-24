require('crates').setup {
    null_ls = {
        enabled = true,
        name = "crates.nvim",
    },
}

local function get_rust_analyzer_path()
    local handle = io.popen("rustup which rust-analyzer")
    local result = handle:read("*a")
    handle:close()
    return result:match("^(.-)%s*$") -- Trim the result
end

local rust_analyzer_path = get_rust_analyzer_path()

if rust_analyzer_path == "" then
    print("rust-analyzer not found")
    return
end

vim.g.rustaceanvim = {
    tools = {
        executor = require("rustaceanvim.executors.toggleterm"),
        inlay_hints = {
        },
    },
    server = {
        cmd = { rust_analyzer_path },
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        ["rust-analyzer"] = {
            assist = {
                importMergeBehavior = "last",
                importPrefix = "by_self",
            },
            cargo = {
                -- loadOutDirsFromCheck = true,
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
                -- enable = true,
            },
        },
    },
    -- on_init = function(client)
    --     local config = client.config.settings["rust-analyzer"]

    --     for k,folder in pairs(client.workspace_folders) do
    --         local path = folder.name

    --         if path == "/Users/dark/gitea/comforest/firmware" then
    --             config.linkedProjects = {
    --                 "Cargo.toml",
    --                 "cross/sensor/Cargo.toml",
    --                 "cross/hub/Cargo.toml",
    --                 "cross/powerbox/Cargo.toml",
    --                 "cross/bootloader/Cargo.toml",
    --             }
    --             config.procMacro = {
    --                 enable = true,
    --             }

    --             client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
    --             return true
    --         end
    --     end

    --     return true
    -- end,
}
