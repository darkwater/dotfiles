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

function run_cmd(title, cmd, max_lines)
    if max_lines == nil then
        max_lines = 1
    end

    return function()
        local lines = {}
        while #lines < max_lines - 1 do
            table.insert(lines, "")
        end
        table.insert(lines, "$ " .. cmd)

        local notification = require("notify")(lines, vim.log.levels.INFO, {
            title = title,
            timeout = 60000,
            max_lines = max_lines,
        })

        -- local task = require("overseer").new_task {
        --     cmd = cmd,
        -- }
        -- task:start()

        -- require("notify")("foo", vim.log.levels.INFO, {
        --     replace = notification.id,
        -- })
        local job_id = vim.fn.jobstart(cmd, {
            on_stdout = function(j, data, event)
                for _, line in ipairs(data) do
                    if line ~= "" then
                        table.insert(lines, line)
                        while #lines > max_lines do
                            table.remove(lines, 1)
                        end
                        notification = require("notify")(lines, vim.log.levels.INFO, {
                            replace = notification.id,
                        })
                    end
                end
            end,
            on_stderr = function(j, data, event)
                for _, line in ipairs(data) do
                    if line ~= "" then
                        table.insert(lines, line)
                        while #lines > max_lines do
                            table.remove(lines, 1)
                        end
                        notification = require("notify")(lines, vim.log.levels.ERROR, {
                            replace = notification.id,
                        })
                    end
                end
            end,
            on_exit = function(j, code, event)
                if code == 0 then
                    body = table.concat(lines, "\n")
                    notification = require("notify")(body, vim.log.levels.INFO, {
                        title = "Done",
                        replace = notification.id,
                        timeout = 2000,
                    })
                else
                    notification = require("notify")("Error!", vim.log.levels.ERROR, {
                        replace = notification.id,
                        timeout = 5000,
                    })
                end
            end,
        })
    end
end

local nvimdir = vim.fn.stdpath "config"

local telescope = require("telescope.builtin")
local hop = require("hop")
local flutter = require("flutter")

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

function hover()
    if vim.fn.expand('%:t') == 'Cargo.toml' and require('crates').popup_available() then
        require('crates').show_popup()
    else
        vim.lsp.buf.hover()
    end
end

local keymap = {}

keymap.K = { hover, "Hover" }
keymap["<C-S-k>"] = { vim.lsp.buf.signature_help, "Signature help" }
vim.keymap.set("v", "K", hover)
vim.keymap.set("i", "<C-S-k>", "<Cmd>lua vim.lsp.buf.signature_help()<CR>", { noremap = true })

keymap.d = {}
keymap.d.s = {}
-- TODO: doesn't work
keymap.d.s.f = { "dt(ds)", "Delete surrounding function", { noremap = false } }

keymap.g = {}
keymap.g.d = { telescope.lsp_definitions, "Go to definition" }
keymap.g.t = { telescope.lsp_type_definitions, "Go to type definition" }

keymap["<leader>"] = { name = "+leader" }

keymap["<M-Bslash>"] = { "<Nop>", "No-op" }
-- keymap["<Bslash>"] = { function()
--     require("flutter").toggle_flutter_terminal("flutter run")
-- end, "Run Executor" }

-- keymap["<Bslash>"] = { "<leader><leader>", "+language-specific", noremap = false }
-- keymap["<leader>"] = { name = "+language-specific" }
keymap["<leader>"].F = { name = "+flutter" }
keymap["<leader>"].F.a = { name = "+android" }
keymap["<leader>"].F.a.c = {
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
keymap["<leader>"].F.f = { with_opts(flutter.toggle_flutter_terminal, "flutter run"), "Run" }
keymap["<leader>"].F.r = { flutter.send_to_flutter("r"), "Hot reload" }
keymap["<leader>"].F.R = { flutter.send_to_flutter("R"), "Hot restart" }
keymap["<leader>"].F.q = { flutter.send_to_flutter("q"), "Stop" }
keymap["<leader>"].F.b = { run_cmd("Build runner", "dart run build_runner build", 5), "Build runner" }

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

local diag_opts = { severity_limit = "error", disable_coordinates = true }
keymap["<leader>"].l = { name = "+lsp" }
keymap["<leader>"].l.a = { vim.lsp.buf.code_action, "Code actions" }
keymap["<leader>"].l.c = { telescope.lsp_incoming_calls, "Incoming calls" }
keymap["<leader>"].l.C = { telescope.lsp_outgoing_calls, "Outgoing calls" }
keymap["<leader>"].l.e = { with_opts(telescope.diagnostics, diag_opts), "Errors" }
keymap["<leader>"].l.d = { telescope.diagnostics, "All diagnostics" }
keymap["<leader>"].l.i = { telescope.lsp_implementations, "Implementations" }
keymap["<leader>"].l.r = { telescope.lsp_references, "References" }
keymap["<leader>"].l.s = { telescope.lsp_document_symbols, "Symbols (document)" }
keymap["<leader>"].l.S = { with_input("Workspace symbol search:", "query", telescope.lsp_workspace_symbols), "Symbols (workspace)" }

keymap["<leader>"].p = { name = "+project/plugins" }
keymap["<leader>"].p.i = { Cmd("PlugInstall"), "Install plugins" }
keymap["<leader>"].p.u = { Cmd("PlugUpdate"), "Install plugins" }
keymap["<leader>"].p.f = { Cmd("Telescope find_files"), "Find file" }
keymap["<leader>"].p.g = { with_input("Grep for:", "search", telescope.grep_string), "Grep" }
keymap["<leader>"].p.G = { telescope.live_grep, "Live grep" }
keymap["<leader>"].p[","] = { Cmd("Telescope find_files cwd="..nvimdir), "Editor config" }

keymap["<leader>"].r = { name = "+rust" }
keymap["<leader>"].r.c = { Cmd("RustLsp openCargo"), "Open Cargo.toml" }
-- keymap["<leader>"].r.R = { Cmd("RustLsp runnables"), "Run..." }
keymap["<leader>"].r.R = { function()
    require("toggleterm.terminal").Terminal
    :new({
        dir = vim.fn.getcwd(),
        cmd = "cargo run",
        close_on_exit = false,
        on_open = function(t)
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes([[<C-\><C-n>]], true, true, true), '', true)
            vim.api.nvim_buf_set_keymap(t.bufnr, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true })
        end,
    })
    :toggle()
end, "Run" }
keymap["<leader>"].r.r = { function()
    require("toggleterm.terminal").Terminal
    :new({
        dir = vim.fn.getcwd(),
        cmd = "cargo run",
        close_on_exit = true,
        on_open = function(t)
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes([[<C-\><C-n>]], true, true, true), '', true)
            vim.api.nvim_buf_set_keymap(t.bufnr, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true })
        end,
    })
    :toggle()
end, "Run" }
keymap["<leader>"].r.J = { Cmd("RustLsp joinLines"), "Join lines" }
keymap["<leader>"].r.u = { Cmd("RustLsp parentModule"), "Jump to parent module" }
keymap["<leader>"].r.m = { Cmd("RustLsp expandMacro"), "Expand macro" }
keymap["<leader>"].r.a = {
    function()
        vim.ui.input(
            "Cargo add:",
            function(args)
                vim.cmd("!cargo add " .. args)
            end
        )
    end,
    "Add dependency",
}

keymap["<leader>"].s = { name = "+symbol" }
keymap["<leader>"].s.e = { vim.lsp.buf.rename, "Rename symbol" }

keymap["<leader>"].T = { name = "+Telescope" }
keymap["<leader>"].T.T = { telescope.builtin, "Telescope pickers" }
keymap["<leader>"].T.A = { telescope.autocommands, "Autocommands" }
keymap["<leader>"].T.b = { telescope.current_buffer_fuzzy_find, "Current buffer" }
keymap["<leader>"].T.B = { telescope.buffers, "Buffers" }
keymap["<leader>"].T.c = { telescope.loclist, "Location list" }
keymap["<leader>"].T.C = { telescope.commands, "Plugin/user commands" }
keymap["<leader>"].T.f = { telescope.git_files, "Find git files" }
keymap["<leader>"].T.F = { with_opts(telescope.find_files, { hidden = true }), "Find all files" }
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

keymap["'"] = { hop.hint_words, "Last buffer" }

keymap["<Enter>"] = { Cmd("b#"), "Last buffer" }

keymap["<C-'>"] = {
    function()
        require("nvterm.terminal").toggle "vertical"
    end,
    "Toggle terminal",
}
keymap["<leader>"]["'"] = keymap["<C-'>"]
vim.keymap.set("t", "<C-'>", "<Cmd>lua require('nvterm.terminal').toggle('vertical')<CR>")

wk.register(keymap)
