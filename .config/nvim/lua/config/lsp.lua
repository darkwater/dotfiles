local lsp = require("lspconfig")
-- local lsp_status = require("lsp-status")

local null_ls = require('null-ls')

local jira_completion = {}
jira_completion.name = "jira_completion"
jira_completion.method = null_ls.methods.COMPLETION
jira_completion.filetypes = {}
jira_completion.generator = {
    async = true,
    fn = function(params, done)
        local cword = vim.fn.expand("<cWORD>"):match("([A-Z]+%-)")

        if cword ~= "SIC-" then
            done {
                isIncomplete = true,
            }
            return
        end

        -- read lines from ~/.jira/issues.txt
        local issues = {}
        local f = io.open(os.getenv("HOME") .. "/.jira/issues.txt", "r")
        if f then
            for line in f:lines() do
                local fields = {}
                for field in line:gmatch("[^\t]+") do
                    table.insert(fields, field)
                end
                local kind = fields[1]
                local id = fields[2]
                local summary = fields[3]
                local status = fields[4]
                local priority = fields[5]
                local assignee = fields[6] or "-"

                table.insert(issues, {
                    label = id .. "  " .. summary,
                    insertText = id .. " " .. summary,
                    documentation = {
                        id,
                        "Kind:     " .. kind,
                        "Summary:  " .. summary,
                        "Status:   " .. status,
                        "Priority: " .. priority,
                        "Assignee: " .. assignee,
                        "",
                        summary,
                    },
                    data = {
                        jira_issue = true,
                        status = status,
                    },
                })
            end
            f:close()
        end

        -- local s = ""
        -- s = s .. (vim.inspect(5))
        -- s = s .. (vim.inspect(issues))
        -- s = s .. (vim.inspect(10))
        -- vim.notify(s)

        -- return completion items
        done {
            {
                items = issues,
                isIncomplete = false,
            },
        }
    end
}

local jira_hover = {}
jira_hover.name = "jira_hover"
jira_hover.method = null_ls.methods.HOVER
jira_hover.filetypes = {}
jira_hover.generator = {
    async = true,
    fn = function(params, done)
        local cword = vim.fn.expand("<cWORD>"):match("([A-Z]+%-[0-9]+)")

        local f = io.open(os.getenv("HOME") .. "/.jira/issues.txt", "r")
        if f then
            for line in f:lines() do
                local fields = {}
                for field in line:gmatch("[^\t]+") do
                    table.insert(fields, field)
                end
                local id = fields[2]

                if cword == id then
                    local kind = fields[1]
                    local summary = fields[3]
                    local status = fields[4]
                    local priority = fields[5]
                    local assignee = fields[6] or "-"

                    done {
                        id,
                        "Kind:     " .. kind,
                        "Summary:  " .. summary,
                        "Status:   " .. status,
                        "Priority: " .. priority,
                        "Assignee: " .. assignee,
                        "",
                        summary,
                    }
                    return
                end
            end
        end

        done()
    end
}

null_ls.setup {
    sources = {
        jira_completion,
        jira_hover,
    },
}

require("pest-vim").setup {}

-- require("lsp-progress").setup {}
-- require("fidget").setup {
--     text = {
--         spinner = {
--             "[    ]",
--             "[=   ]",
--             "[==  ]",
--             "[=== ]",
--             "[ ===]",
--             "[  ==]",
--             "[   =]",
--         },
--         done = "",
--     },
--     window = {
--         -- try setting this to 100 and see if the background is still black
--         blend = 0, -- https://github.com/neovim/neovim/issues/10685
--     },
-- }

-- lsp_status.register_progress()
-- lsp_status.config {
--     diagnostics = false,
--     indicator_separator = "////",
--     component_separator = "/",
--     status_symbol = {},
-- }

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

vim.api.nvim_create_augroup("LspAttach_inlayhints", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
    group = "LspAttach_inlayhints",
    callback = function(args)
        if not (args.data and args.data.client_id) then
            return
        end

        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        require("lsp-inlayhints").on_attach(client, bufnr)
    end,
})
