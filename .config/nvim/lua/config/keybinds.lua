local wk = require("which-key")

wk.setup {
    show_help = false,
}

function Cmd(cmd)
    return "<Cmd>" .. cmd .. "<CR>"
end

local nvimdir = vim.fn.stdpath "config"

local keymap = {}
keymap["<leader>"] = { name = "+leader" }

keymap["<leader>"]["<leader>"] = { name = "+language-specific" }
keymap["<leader>"]["<leader>"].f = { name = "+flutter" }
keymap["<leader>"]["<leader>"].f.a = { name = "+android" }
keymap["<leader>"]["<leader>"].f.a.c = {
    function()
        vim.ui.input(
            "Enter IP address: ",
            function(ip)
                vim.cmd("!adb connect " .. ip)
            end
        )
    end,
    "Connect over TCP",
}
keymap["<leader>"]["<leader>"].f.f = { Cmd("FlutterRun"), "Run" }
keymap["<leader>"]["<leader>"].f.r = { Cmd("FlutterRestart"), "Restart" }
keymap["<leader>"]["<leader>"].f.h = { Cmd("FlutterReload"), "Hot reload" }
keymap["<leader>"]["<leader>"].f.d = { Cmd("FlutterDevices"), "Devices" }
keymap["<leader>"]["<leader>"].f.s = { Cmd("FlutterQuit"), "Stop" }

keymap["<leader>"]["'"] = {
    function()
        require("nvterm.terminal").toggle "vertical"
    end,
    "Toggle terminal",
}

keymap["<leader>"].f = { name = "+file" }
keymap["<leader>"].f.s = { Cmd("source %"), "Source file" }

keymap["<leader>"].g = { name = "+git" }
keymap["<leader>"].g.b = { Cmd("Telescope git_branches"), "Branches" }
keymap["<leader>"].g.B = { Cmd("Gitsigns blame_line"), "Blame line" }
keymap["<leader>"].g.c = { Cmd("Telescope git_commits"), "Commits" }
keymap["<leader>"].g.d = {
    Cmd("Gitsignstoggle_linehl") ..
    Cmd("Gitsigns toggle_deleted"),
    "Toggle inline diff",
}
keymap["<leader>"].g.f = { Cmd("Telescope git_bcommits"), "File history" }
keymap["<leader>"].g.p = { Cmd("Gitsigns preview_hunk_inline"), "Preview hunk" }
keymap["<leader>"].g.s = { Cmd("Telescope git_status"), "Status" }

keymap["<leader>"].p = { name = "+project/plugins" }
keymap["<leader>"].p.i = { Cmd("PlugInstall"), "Install plugins" }
keymap["<leader>"].p.u = { Cmd("PlugUpdate"), "Install plugins" }
keymap["<leader>"].p.f = { Cmd("Telescope find_files"), "Find file" }
keymap["<leader>"].p[","] = { Cmd("Telescope find_files cwd="..nvimdir), "Editor config" }

keymap["<leader>"].w = { name = "+window" }
keymap["<leader>"].w.h = { "<C-w>h", "Move left" }
keymap["<leader>"].w.j = { "<C-w>j", "Move down" }
keymap["<leader>"].w.k = { "<C-w>k", "Move up" }
keymap["<leader>"].w.l = { "<C-w>l", "Move right" }
keymap["<leader>"].w.v = { "<C-w>v", "Split vertically" }
keymap["<leader>"].w.s = { "<C-w>s", "Split horizontally" }
keymap["<leader>"].w.q = { "<C-w>q", "Close window" }
keymap["<leader>"].w.Q = { Cmd("qa"), "Close all windows" }
keymap["<leader>"].w.o = { Cmd("only"), "Close other windows" }

keymap["["] = { name = "+previous" }
keymap["["].g = { Cmd("Gitsigns prev_hunk"), "Previous hunk" }
keymap["["].q = { Cmd("cprev"), "Previous quickfix" }
keymap["["].l = { Cmd("lprev"), "Previous location" }

keymap["]"] = { name = "+next" }
keymap["]"].g = { Cmd("Gitsigns next_hunk"), "Next hunk" }
keymap["]"].q = { Cmd("cnext"), "Next quickfix" }
keymap["]"].l = { Cmd("lnext"), "Next location" }

keymap["<S-space>"] = { Cmd("b#"), "Last buffer" }

wk.register(keymap)
