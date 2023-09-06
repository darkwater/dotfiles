local function LspStatus()
    return require("lsp-progress").progress({
        format = function(messages)
            local active_clients = vim.lsp.get_active_clients()
            local client_count = #active_clients
            if #messages > 0 then
                return " "
                .. client_count
                .. " "
                .. table.concat(messages, " ")
            end
            if #active_clients <= 0 then
                return " None"
            else
                local client_names = {}
                for i, client in ipairs(active_clients) do
                    if client and client.name ~= "" then
                        table.insert(client_names, client.name)
                        -- print(
                        --     "client[" .. i .. "]:" .. vim.inspect(client.name)
                        -- )
                    end
                end
                return " "
                .. table.concat(client_names, ", ")
            end
        end,
    })
end

local function LspClients()
    return require("lsp-progress").progress({
        format = function(messages)
            local active_clients = vim.lsp.get_active_clients()
            local client_count = #active_clients
            if #active_clients <= 0 then
                return " none"
            else
                local client_names = {}
                for i, client in ipairs(active_clients) do
                    if client and client.name ~= "" then
                        table.insert(client_names, client.name)
                        -- print(
                        --     "client[" .. i .. "]:" .. vim.inspect(client.name)
                        -- )
                    end
                end
                return 
                " "
                .. table.concat(client_names, ", ")
            end
        end,
    })
end

local ayu_mirage = require("lualine.themes.ayu_mirage")
ayu_mirage.normal.a.bg = "#59c2ff"
-- ayu_mirage.normal.c.fg = "#000000"

require("lualine").setup {
    options = {
        -- hh ─  9472   HH ━  9473   vv │  9474   VV ┃  9475   3- ┄  9476   3_ ┅  9477   3! ┆  9478   3/ ┇  9479   4- ┈  9480   4_ ┉  9481   4! ┊  9482   4/ ┋  9483   dr ┌  9484   dR ┍  9485   Dr ┎  9486   DR ┏  9487   dl ┐  9488   dL ┑  9489   Dl ┒  9490   LD ┓  9491   ur └  9492   uR ┕  9493   Ur ┖  9494   UR ┗  9495
        theme = ayu_mirage,
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        },
    },
    sections = {
        lualine_a = {{
            "filename",
            path = 1,
        }},
        lualine_b = {"diagnostics"},
        lualine_c = {},
        lualine_x = { LspClients },
        lualine_y = {"diff", "filetype"},
        lualine_z = {"location", "progress"},
    },
    inactive_sections = {
        lualine_a = {{
            "filename",
            path = 1,
        }},
        lualine_b = {"diagnostics"},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {"diff", "filetype"},
        lualine_z = {"location", "progress"},
    },
    extensions = { "man", "neo-tree", "quickfix" },
}

vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
vim.api.nvim_create_autocmd("User LspProgressStatusUpdated", {
    group = "lualine_augroup",
    callback = require("lualine").refresh,
})
