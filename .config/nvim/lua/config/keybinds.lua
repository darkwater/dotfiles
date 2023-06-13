local wk = require("which-key")

wk.setup {
    show_help = false,
    operators = {
        gc = "Comment",
        ["gc"] = "Comment",
    },
}

function Cmd(cmd)
    return "<Cmd>" .. cmd .. "<CR>"
end

local nvimdir = vim.fn.stdpath "config"

local telescope = require("telescope.builtin")
function with_input(prompt, name, fn)
    return function()
        vim.ui.input(prompt, function(input)
            local opts = { [name] = input }
            fn(opts)
        end)
    end
end
function with_opts(fn, opts)
    return function()
        fn(opts)
    end
end

local keymap = {}

keymap.K = { vim.lsp.buf.hover, "Hover" }
keymap["<C-k>"] = { vim.lsp.buf.signature_help, "Signature help" }
vim.keymap.set("i", "<C-k>", "<Cmd>lua vim.lsp.buf.signature_help()<CR>", { noremap = true })

keymap.g = {}
keymap.g.d = { telescope.lsp_definitions, "Go to definition" }
keymap.g.t = { telescope.lsp_type_definitions, "Go to type definition" }

keymap["<leader>"] = { name = "+leader" }

keymap["\\"] = { "<leader><leader>", "+language-specific", noremap = false }
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

keymap["<leader>"].f = { name = "+file" }
keymap["<leader>"].f.s = { Cmd("source %"), "Source file" }
keymap["<leader>"].f.f = { vim.lsp.buf.format, "Format file" }

keymap["<leader>"].g = { name = "+git" }
keymap["<leader>"].g.b = { Cmd("Telescope git_branches"), "Branches" }
keymap["<leader>"].g.B = { Cmd("Gitsigns blame_line"), "Blame line" }
keymap["<leader>"].g.c = { Cmd("Telescope git_commits"), "Commits" }
keymap["<leader>"].g.d = {
    Cmd("Gitsigns toggle_linehl") ..
    Cmd("Gitsigns toggle_deleted"),
    "Toggle inline diff",
}
keymap["<leader>"].g.f = { Cmd("Telescope git_bcommits"), "File history" }
keymap["<leader>"].g.p = { Cmd("Gitsigns preview_hunk_inline"), "Preview hunk" }
keymap["<leader>"].g.s = { Cmd("Telescope git_status"), "Status" }
keymap["<leader>"].g.S = { Cmd("Telescope git_stash"), "Stash" }

local diag_opts = { severity_limit = "warn", disable_coordinates = true }
keymap["<leader>"].l = { name = "+lsp" }
keymap["<leader>"].l.a = { vim.lsp.buf.code_action, "Code actions" }
keymap["<leader>"].l.c = { telescope.lsp_incoming_calls, "Incoming calls" }
keymap["<leader>"].l.C = { telescope.lsp_outgoing_calls, "Outgoing calls" }
keymap["<leader>"].l.e = { with_opts(telescope.diagnostics, diag_opts), "Errors/warnings" }
keymap["<leader>"].l.d = { telescope.diagnostics, "All diagnostics" }
keymap["<leader>"].l.i = { telescope.lsp_implementations, "Implementations" }
keymap["<leader>"].l.r = { telescope.lsp_references, "References" }
keymap["<leader>"].l.s = { telescope.lsp_document_symbols, "Symbols (document)" }
keymap["<leader>"].l.S = { telescope.lsp_workspace_symbols, "Symbols (workspace)" }

keymap["<leader>"].p = { name = "+project/plugins" }
keymap["<leader>"].p.i = { Cmd("PlugInstall"), "Install plugins" }
keymap["<leader>"].p.u = { Cmd("PlugUpdate"), "Install plugins" }
keymap["<leader>"].p.f = { Cmd("Telescope find_files"), "Find file" }
keymap["<leader>"].p[","] = { Cmd("Telescope find_files cwd="..nvimdir), "Editor config" }

keymap["<leader>"].s = { name = "+symbol" }
keymap["<leader>"].s.e = { vim.lsp.buf.rename, "Rename symbol" }

keymap["<leader>"].T = { name = "+Telescope" }
keymap["<leader>"].T.T = { telescope.builtin, "Telescope pickers" }
keymap["<leader>"].T.A = { telescope.autocommands, "Autocommands" }
keymap["<leader>"].T.b = { telescope.buffers, "Buffers" }
keymap["<leader>"].T.c = { telescope.loclist, "Location list" }
keymap["<leader>"].T.C = { telescope.commands, "Plugin/user commands" }
keymap["<leader>"].T.f = { telescope.git_files, "Find git files" }
keymap["<leader>"].T.F = { with_opts(telescope.find_files, { hidden = true }), "Find all files" }
keymap["<leader>"].T.g = { with_input("Grep for:", "search", telescope.grep_string), "Grep" }
keymap["<leader>"].T.G = { telescope.live_grep, "Live grep" }
keymap["<leader>"].T.H = { telescope.highlights, "Highlights" }
keymap["<leader>"].T.M = { telescope.man_pages, "Man pages" }
keymap["<leader>"].T.o = { telescope.vim_options, "Vim options" }
keymap["<leader>"].T.P = { telescope.planets, "Use the telescope..." }
keymap["<leader>"].T.q = { telescope.quickfix, "Quickfix" }
keymap["<leader>"].T.r = { telescope.oldfiles, "Recent files" }
keymap["<leader>"].T.t = { telescope.colorscheme, "Colorschemes" }
keymap["<leader>"].T["'"] = { telescope.marks, "Marks" }
keymap["<leader>"].T['"'] = { telescope.registers, "Registers" }
keymap["<leader>"].T[":"] = { telescope.command_history, "Command history" }
keymap["<leader>"].T["/"] = { telescope.search_history, "Search history" }
keymap["<leader>"].T["?"] = { telescope.help_tags, "Help tags" }
keymap["<leader>"].T["."] = { telescope.resume, "Resume last picker" }

keymap["<leader>"].w = { name = "+window" }
keymap["<leader>"].w.s = { Cmd("Neotree document_symbols"), "Document symbols" }
keymap["<leader>"].w.Q = { Cmd("qa"), "Close all windows" }
keymap["<leader>"].w.t = { Cmd("Neotree"), "Toggle Neotree" } -- also see neotree.lua mappings

keymap["<leader>"].K = { vim.diagnostic.open_float, "Show diagnostic details" }

keymap["["] = { name = "+previous" }
keymap["["].e = { vim.diagnostic.goto_prev, "Previous error" }
keymap["["].h = { Cmd("Gitsigns prev_hunk"), "Previous hunk" }
keymap["["].q = { Cmd("cprev"), "Previous quickfix" }
keymap["["].l = { Cmd("lprev"), "Previous location" }

keymap["]"] = { name = "+next" }
keymap["]"].e = { vim.diagnostic.goto_next, "Next error" }
keymap["]"].h = { Cmd("Gitsigns next_hunk"), "Next hunk" }
keymap["]"].q = { Cmd("cnext"), "Next quickfix" }
keymap["]"].l = { Cmd("lnext"), "Next location" }

keymap["<S-space>"] = { Cmd("b#"), "Last buffer" }

keymap["<C-'>"] = {
    function()
        require("nvterm.terminal").toggle "vertical"
    end,
    "Toggle terminal",
}
keymap["<leader>"]["'"] = keymap["<C-'>"]
vim.keymap.set("t", "<C-'>", "<Cmd>lua require('nvterm.terminal').toggle('vertical')<CR>")

wk.register(keymap)
