local theta = require("alpha.themes.theta")
local dashboard = require("alpha.themes.dashboard")

-- theta.section.buttons.val = {
-- }

table.insert(theta.config.layout, 5, {
    type = "padding",
    val = 2,
})

table.insert(theta.config.layout, 6, {
    type = "group",
    val = {
        { type = "text", val = "Projects", opts = { hl = "SpecialComment", position = "center" } },
        { type = "padding", val = 1 },
        dashboard.button("b", "󰫢  Bar", ":cd ~/github/darkwater/fdls<CR>"),
    },
    position = "center",
})

require("alpha").setup(theta.config)

-- require("startup").setup {
--     options = {
--         mapping_keys = false,
--         disable_statuslines = true,
--         cursor_column = 0,
--     },
--     mappings = {
--         execute_command = "<CR>",
--         open_file = "o",
--         open_file_split = "<c-o>",
--         open_section = "<TAB>",
--         open_help = "?",
--     },
--     colors = {
--         background = "#1f2430",
--     },
--     parts = {"s_oldfiles", "s_commands"},
--     s_oldfiles = {
--         type = "oldfiles",
--         align = "center",
--         highlight = "Constant",
--         oldfiles_directory = true,
--     },
--     s_commands = {
--         type = "mapping",
--         align = "center",
--         highlight = "Constant",
--         content = {
--             [" Find File"] = { "?", "Telescope find_files", "<leader>ff" },
--             [" Find Word"] = { "?", "Telescope live_grep", "<leader>lg" },
--             [" Recent Files"] = { "?", "Telescope oldfiles", "<leader>of" },
--             [" File Browser"] = { "?", "Telescope file_browser", "<leader>fb" },
--             [" Colorschemes"] = { "?", "Telescope colorscheme", "<leader>cs" },
--             [" New File"] = { "?", "lua require'startup'.new_file()", "<leader>nf" },
--         },
--     },
-- }
