-- NOTE: loaded by <leader>x

vim.notify("Loading xcodebuild", vim.log.levels.INFO)

require("xcodebuild").setup {}
require("xcodebuild.integrations.lsp").restart_sourcekit_lsp()

function Cmd(cmd)
    return "<Cmd>" .. cmd .. "<CR>"
end

local keymap = {}

keymap.x = { Cmd("XcodebuildBuildRun"), "Build & run" }
keymap.D = { Cmd("XcodebuildSelectDevice"), "Select device" }
keymap.S = { Cmd("XcodebuildBootSimulator"), "Boot simulator" }

require("which-key").register {
    ["<leader>"] = {
        T = { X = { Cmd("XcodebuildPicker"), "Xcodebuild" }},
        x = keymap,
    },
}
