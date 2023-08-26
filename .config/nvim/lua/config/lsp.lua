local lsp = require("lspconfig")

vim.diagnostic.config {
    virtual_text = true,
    severity_sort = true,
    float = { source = "if_many" },
}

lsp.denols.setup {
    root_dir = lsp.util.root_pattern("deno.json"),
}

-- lsp.rust_analyzer.setup {
--     settings = {
--         ["rust-analyzer"] = {
--             cargo = {
--                 loadOutDirsFromCheck = true,
--             },
--             checkOnSave = {
--                 command = "clippy",
--             },
--             check = {
--                 command = "clippy",
--             },
--             completion = {
--                 postfix = {
--                     enable = false,
--                 },
--             },
--             -- linkedProjects = {},
--             procMacro = {
--                 enable = true,
--             },
--         },
--     },
--     capabilities = require("cmp_nvim_lsp").default_capabilities(),
--     -- on_init = function(client)
--     --     local config = client.config.settings["rust-analyzer"]

--     --     for k,folder in pairs(client.workspace_folders) do
--     --         local path = folder.name

--     --         if path == "/Users/dark/gitea/comforest/firmware" then
--     --             config.linkedProjects = {
--     --                 "Cargo.toml",
--     --                 "cross/sensor/Cargo.toml",
--     --                 "cross/hub/Cargo.toml",
--     --                 "cross/powerbox/Cargo.toml",
--     --                 "cross/bootloader/Cargo.toml",
--     --             }
--     --             config.procMacro = {
--     --                 enable = true,
--     --             }

--     --             client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
--     --             return true
--     --         end
--     --     end

--     --     return true
--     -- end,
-- }
