require("crates").setup {
    thousands_separator = "_",
    enable_update_available_warning = false,
    -- null_ls = {
    lsp = {
        enabled = true,
        name = "crates",

        actions = true,
        completion = true,
        hover = true,
    },
    text = {
        loading = "     Loading",
        version = "     %s",
        prerelease = "     %s",
        yanked = "     %s",
        nomatch = "     No match",
        upgrade = "     %s",
        error = "     Error fetching crate",
    },
    completion = {
        cmp = {
            enabled = true,
        },
        crates = {
            enabled = true,
            min_chars = 2,
            max_results = 15,
        },
    },
}

require("ferris").setup {}

vim.g.rustaceanvim = function()
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

    -- Update this path
    local extension_path = vim.env.HOME .. '/.vscode/extensions/vadimcn.vscode-lldb-1.10.0/'
    local codelldb_path = extension_path .. 'adapter/codelldb'
    local liblldb_path = extension_path .. 'lldb/lib/liblldb'

    -- The liblldb extension is .so for Linux and .dylib for MacOS
    liblldb_path = liblldb_path .. ".dylib"

    local cfg = require('rustaceanvim.config')
    return {
        tools = {
            executor = require("rustaceanvim.executors.toggleterm"),
            inlay_hints = {
                auto = false,
            },
        },
        server = {
            cmd = { rust_analyzer_path },
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
            settings = function (path)
                local linkedProjects

                if path == "/home/dark/gitea/comforest/firmware"
                    or path == "/home/dark/gitea/comforest/firmware/cross" then
                    linkedProjects = {
                        "/home/dark/gitea/comforest/firmware/Cargo.toml",
                        "/home/dark/gitea/comforest/firmware/cross/Cargo.toml",
                    }
                end

                if path == "/home/dark/atsushi/firmware"
                    or path == "/home/dark/atsushi/firmware/cross" then
                    linkedProjects = {
                        "/home/dark/atsushi/firmware/Cargo.toml",
                        "/home/dark/atsushi/firmware/cross/Cargo.toml",
                    }
                end

                if path == "/home/dark/github/sinewave-ee/fouling-sensor"
                    or path == "/home/dark/github/sinewave-ee/fouling-sensor/cross" then
                    linkedProjects = {
                        "/home/dark/github/sinewave-ee/fouling-sensor/Cargo.toml",
                        "/home/dark/github/sinewave-ee/fouling-sensor/gateway/Cargo.toml",
                    }
                end

                return {
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
                            enable = false,
                            disabled = {
                                -- "unresolved-proc-macro",
                                "inactive-code",
                                "trait-impl-incorrect-safety",
                                "remove-unnecessary-else",
                            },
                        },
                        procMacro = {
                            enable = true,
                        },
                        linkedProjects = linkedProjects,
                    },
                }
            end,
        },
        -- dap = {
        --     adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
        -- },
    }
end

-- vim.g.rustaceanvim = {
    -- dap = {
    --     adapter = {
    --         type = "probe-rs",
    --         port = "50000",
    --     },
    --     configuration = {
    --         type = "probe-rs",
    --         name = "Debug Firmware",
    --         request = "launch",
    --         program = "${workspaceFolder}/target/thumbv7em-none-eabihf/debug/powerbox",
    --         chip = "STM32L433RC",
    --         coreConfigs = {
    --             {
    --                 programBinary = "${workspaceFolder}/target/thumbv7em-none-eabihf/debug/powerbox",
    --             },
    --         },
    --     },
    -- },
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
-- }
