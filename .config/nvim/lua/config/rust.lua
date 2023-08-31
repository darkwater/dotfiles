require('null-ls').setup {}

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

require("rust-tools").setup {
    tools = {
        executor = require("rust-tools.executors").quickfix,
        inlay_hints = {
        },
    },
    server = {
        cmd = { rust_analyzer_path },
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        settings = {
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
    },
}
