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
        dashboard.button("hb", "󰫢  Bar", ":cd ~/github/darkwater/hoshi-bar<CR>"),
        dashboard.button("hl", "󰫢  Launcher", ":cd ~/github/darkwater/hoshi-launcher<CR>"),
        dashboard.button("hs", "󰫢  Settings", ":cd ~/github/darkwater/hoshi-settings<CR>"),
        { type = "padding", val = 2 },
        { type = "text", val = "Personal", opts = { hl = "SpecialComment", position = "center" } },
        { type = "padding", val = 1 },
        dashboard.button("pt", "  Tetsu", ":cd ~/github/darkwater/tetsu<CR>"),
        dashboard.button("ph", "󰋜  Home", ":cd ~/github/darkwater/home<CR>"),
        dashboard.button("psc", "  Steam Clip Exporter", ":cd ~/github/darkwater/steam-clip-exporter<CR>"),
        { type = "padding", val = 2 },
        { type = "text", val = "Libraries", opts = { hl = "SpecialComment", position = "center" } },
        { type = "padding", val = 1 },
        dashboard.button("lws", "  Wayland Shell", ":cd ~/github/flafydev/wayland_shell<CR>"),
        dashboard.button("lxd", "  XDG Desktop Entries", ":cd ~/github/darkwater/xdg_desktop_entries<CR>"),
        dashboard.button("lim", "󰦆  Iced Material", ":cd ~/github/darkwater/iced-material<CR>"),
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
        { type = "padding", val = 2 },
        { type = "text", val = "Other", opts = { hl = "SpecialComment", position = "center" } },
        { type = "padding", val = 1 },
        dashboard.button("n", "󰧮  Blank file", ":enew<CR>"),
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
