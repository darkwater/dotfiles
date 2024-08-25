local theta = require("alpha.themes.theta")
local dashboard = require("alpha.themes.dashboard")

-- theta.section.buttons.val = {
-- }

theta.config.layout[4].val[1].val = vim.fn.getcwd

theta.config.layout[6] = {
    type = "group",
    val = {
        { type = "text", val = "Hoshi", opts = { hl = "SpecialComment", position = "center" } },
        { type = "padding", val = 1 },
        dashboard.button("hb", "󰫢  Bar", ":cd ~/github/darkwater/fdls<CR>"),
        dashboard.button("hl", "󰫢  Launcher", ":cd ~/github/darkwater/hoshi-launcher<CR>"),
        dashboard.button("hs", "󰫢  Settings", ":cd ~/github/darkwater/hoshi-settings<CR>"),
        { type = "padding", val = 2 },
        { type = "text", val = "Libraries", opts = { hl = "SpecialComment", position = "center" } },
        { type = "padding", val = 1 },
        dashboard.button("lp", "  Pipewire", ":cd ~/github/darkwater/dart-pipewire<CR>"),
        { type = "padding", val = 2 },
        { type = "text", val = "Comforest", opts = { hl = "SpecialComment", position = "center" } },
        { type = "padding", val = 1 },
        dashboard.button("cf", "󰌪  Firmware", ":cd ~/gitea/comforest/firmware<CR>"),
        dashboard.button("css", "󰌪  SICshark v2", ":cd ~/gitea/comforest/sicshark<CR>"),
        dashboard.button("cs1", "󰌪  SICshark", ":cd ~/github/sinewave-ee/sicshark<CR>"),
        { type = "padding", val = 2 },
        { type = "text", val = "Sinewave", opts = { hl = "SpecialComment", position = "center" } },
        { type = "padding", val = 1 },
        dashboard.button("sfs", "󰥛  Fouling Sensor", ":cd ~/github/sinewave-ee/fouling-sensor<CR>"),
    },
    position = "center",
}

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
