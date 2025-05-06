local function LspStatus()
    return require("lsp-progress").progress({
        format = function(messages)
            local active_clients = vim.lsp.get_clients()
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
            local active_clients = vim.lsp.get_clients()
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
ayu_mirage.inactive.c.fg = ayu_mirage.normal.c.fg

local function xcodebuild_device()
  if vim.g.xcodebuild_platform == "macOS" then
    return " macOS"
  end

  if vim.g.xcodebuild_os then
    return " " .. vim.g.xcodebuild_device_name .. " (" .. vim.g.xcodebuild_os .. ")"
  end

  return " " .. vim.g.xcodebuild_device_name
end

------

require("lualine").setup {
    options = {
        -- https://raw.githubusercontent.com/entombedvirus/neovide/2c5dc27b8d940378a69d682a995cdbbd627af243/src/renderer/box_drawing/box_drawing_test.txt
        theme = ayu_mirage,
        section_separators = { left = " ", right = " " },
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
        lualine_c = {"branch"},
        lualine_x = {
            LspClients,
            { "' ' .. vim.g.xcodebuild_last_status", color = { fg = "Gray" } },
            { "'󰙨 ' .. vim.g.xcodebuild_test_plan", color = { fg = "#a6e3a1", bg = "#161622" } },
            { xcodebuild_device, color = { fg = "#f9e2af", bg = "#161622" } },
        },
        lualine_y = {"diff", "filetype"},
        lualine_z = {"location", "progress"},
    },
    inactive_sections = {
        lualine_a = {{
            "filename",
            path = 1,
        }},
        lualine_b = {"diagnostics"},
        lualine_c = {"branch"},
        lualine_x = {},
        lualine_y = {"diff", "filetype"},
        lualine_z = {"location", "progress"},
    },
    extensions = { "man", "neo-tree", "quickfix" },
}

vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
-- vim.api.nvim_create_autocmd("User LspProgressUpdate", {
--     group = "lualine_augroup",
--     callback = require("lualine").refresh,
-- })
