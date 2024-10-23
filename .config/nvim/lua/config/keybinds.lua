local wk = require("which-key")

wk.setup {
    show_help = false,
    icons = {
        mappings = false,
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

function shell(cmd, close_on_exit, env)
    return function()
        require("toggleterm.terminal").Terminal
            :new({
                dir = vim.fn.getcwd(),
                cmd = cmd,
                close_on_exit = close_on_exit,
                env = env,
                on_open = function(t)
                    -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes([[<C-\><C-n>]], true, true, true), '', true)
                    -- vim.api.nvim_buf_set_keymap(t.bufnr, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true })
                end,
            })
            :toggle()
    end
end

function bg_cmd(cmd, class)
    return function()
        vim.system({
            "kitty",
            "--directory", vim.fn.getcwd(),
            "--app-id", class,
            "--hold",
            "sh", "-c", cmd,
            detach = true,
        })
    end
end

function bg_key(class, modifier, key)

    return function()
        vim.system({
            "hyprctl",
            "dispatch",
            "sendshortcut",
            modifier..","..key..",class:"..class,
            detach = true,
        })
    end
end

local nvimdir = vim.fn.stdpath "config"
local homedir = vim.fn.expand "$HOME"
local tododir = homedir .. "/sync/todo"
local hyprdir = homedir .. "/.config/hypr"
local dotdir = homedir .. "/dotfiles"

local telescope = require("telescope.builtin")
local hop = require("hop")
-- local flutter = require("flutter")

function with_input(prompt, name, fn)
    return function()
        vim.ui.input(prompt, function(input)
            if input == nil then return end
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

function find_files_in(dir, opts)
    if opts == nil then
        opts = {}
    end

    opts["cwd"] = dir
    return function() telescope.find_files(opts) end
end

local copilot_enabled = true
function toggle_copilot()
    copilot_enabled = not copilot_enabled
    if copilot_enabled then
        vim.cmd "Copilot enable"
        vim.notify "Copilot enabled"
    else
        vim.cmd "Copilot disable"
        vim.notify "Copilot disabled"
    end
end

function toggle_inlay_hints()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end

local virtual_errors_enabled = true
function toggle_virtual_errors()
    virtual_errors_enabled = not virtual_errors_enabled

    vim.diagnostic.config {
        virtual_text = not virtual_errors_enabled,
        virtual_lines = virtual_errors_enabled,
    }
end

function cargo_add()
    vim.ui.input(
        "Cargo add:",
        function(args)
            vim.cmd("!cargo add " .. args)
        end
    )
end

function toggle_venn()
    local venn_enabled = vim.inspect(vim.b.venn_enabled)
    if venn_enabled == "nil" then
        vim.b.venn_enabled = true
        vim.cmd[[setlocal ve=all]]
        -- draw a line on HJKL keystokes
        vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", {noremap = true})
        -- draw a box by pressing "f" with visual selection
        vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "v", "F", ":VBoxD<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "v", "<C-f>", ":VBoxH<CR>", {noremap = true})
    else
        vim.cmd[[setlocal ve=]]
        vim.api.nvim_buf_del_keymap(0, "n", "J")
        vim.api.nvim_buf_del_keymap(0, "n", "K")
        vim.api.nvim_buf_del_keymap(0, "n", "L")
        vim.api.nvim_buf_del_keymap(0, "n", "H")
        vim.api.nvim_buf_del_keymap(0, "v", "f")
        vim.api.nvim_buf_del_keymap(0, "v", "F")
        vim.api.nvim_buf_del_keymap(0, "v", "<C-f>")
        vim.b.venn_enabled = nil
    end
end

wk.add {
    { "K",       vim.lsp.buf.hover,          desc = "Hover",          mode = { "n", "v" } },
    { "<C-S-k>", vim.lsp.buf.signature_help, desc = "Signature help", mode = { "n", "i" } },

    { "<C-S-v>", '"+p',         desc = "Paste from +" },
    { "<C-S-v>", '<C-c>"+p`]a', desc = "Paste from +", mode = "i" },

    { "gd", telescope.lsp_definitions,      desc = "Go to definition" },
    { "gt", telescope.lsp_type_definitions, desc = "Go to type definition" },

    { "<Bslash>", desc = "Toggle inlay hints", toggle_inlay_hints },

    { "<BS>", desc = "Toggle full inline errors", toggle_virtual_errors },

    { "<leader>", group = "leader" },

    { "<leader>f", group = "flutter" },
    { "<leader>ff", bg_cmd("fvm flutter run", "flutter"),  desc = "Flutter run" },
    { "<leader>fr", bg_key("flutter", "",      "r"),       desc = "Hot reload" },
    { "<leader>fR", bg_key("flutter", "SHIFT", "r"),       desc = "Hot restart" },
    { "<leader>fq", bg_key("flutter", "",      "q"),       desc = "Stop" },
    { "<leader>fP", bg_key("flutter", "SHIFT", "p"),       desc = "Toggle performance overlay" },
    { "<leader>fp", bg_key("flutter", "",      "p"),       desc = "Toggle debug painting" },
    { "<leader>ft", shell("fvm flutter test", false),      desc = "Test" },
    { "<leader>fb", bg_cmd("dart run build_runner watch"), desc = "Build runner (watch)" },

    { "<leader>F", group = "file" },
    { "<leader>Fs", Cmd("source %"),    desc = "Source file" },
    { "<leader>Ff", vim.lsp.buf.format, desc = "Format file" },

    { "<leader>g", group = "git" },
    { "<leader>gb", Cmd("Telescope git_branches"),       desc = "Branches" },
    { "<leader>gB", Cmd("Gitsigns blame_line"),          desc = "Blame line" },
    { "<leader>gl", Cmd("Telescope git_commits"),        desc = "Commit log" },
    { "<leader>gL", Cmd("Telescope git_bcommits_range"), desc = "Line history" },
    { "<leader>gF", Cmd("Telescope git_bcommits"),       desc = "File history" },
    { "<leader>gC", Cmd("Git commit"),                   desc = "Commit" },
    { "<leader>gp", Cmd("Gitsigns preview_hunk_inline"), desc = "Preview hunk" },
    { "<leader>gs", Cmd("Telescope git_status"),         desc = "Status" },
    { "<leader>gS", Cmd("Telescope git_stash"),          desc = "Stash" },
    { "<leader>gu", Cmd("Gitsigns reset_hunk"),          desc = "Undo hunk" },
    { "<leader>gd", Cmd("Gitsigns toggle_linehl") .. Cmd("Gitsigns toggle_deleted"), desc = "Toggle inline diff" },

    { "<leader>i", group = "insert" },
    { "<leader>iu", Cmd("read !uuidgen"), desc = "Insert UUID" },

    { "<leader>l", group = "lsp" },
    { "<leader>la", vim.lsp.buf.code_action,        desc = "Code actions", mode = { "n", "v" } },
    { "<leader>lc", telescope.lsp_incoming_calls,   desc = "Incoming calls" },
    { "<leader>lC", telescope.lsp_outgoing_calls,   desc = "Outgoing calls" },
    { "<leader>le", telescope.diagnostics,          desc = "Errors" },
    { "<leader>ld", telescope.diagnostics,          desc = "All diagnostics" },
    { "<leader>lf", vim.lsp.buf.format,             desc = "Format buffer" },
    { "<leader>li", Cmd("Glance implementations"),  desc = "Implementations" },
    { "<leader>lr", vim.lsp.buf.rename,             desc = "Rename symbol" },
    { "<leader>lR", Cmd("Glance references"),       desc = "References" },
    { "<leader>ls", telescope.lsp_document_symbols, desc = "Symbols (document)" },
    { "<leader>lS", with_input("Workspace symbol search:", "query", telescope.lsp_workspace_symbols), desc = "Symbols (workspace)" },

    { "<leader>P", group = "plugins" },
    { "<leader>Pi", Cmd("PlugInstall"), desc = "Install plugins" },
    { "<leader>Pu", Cmd("PlugUpdate"), desc = "Update plugins" },
    { "<leader>Pc", Cmd("PlugClean"), desc = "Clean plugins" },

    { "<leader>p", group = "project" },
    { "<leader>pf", telescope.find_files,                                     desc = "Find file" },
    { "<leader>pG", telescope.live_grep,                                      desc = "Live grep" },
    { "<leader>pg", with_input("Grep for:", "search", telescope.grep_string), desc = "Grep" },
    { "<leader>pr", telescope.oldfiles,                                       desc = "Recent files" },
    { "<leader>ph", find_files_in(hyprdir),                                   desc = "Hyprland config" },
    { "<leader>pt", find_files_in(tododir),                                   desc = "Todo lists" },
    { "<leader>p,", find_files_in(nvimdir),                                   desc = "Neovim config" },
    { "<leader>p.", find_files_in(dotdir, { hidden = true }),                 desc = "Dotfiles" },

    { "<leader>r", group = "rust" },
    { "<leader>rc", shell("cargo clippy", false),              desc = "Clippy" },
    { "<leader>rr", shell("cargo run", true),                  desc = "Run" },
    { "<leader>rR", shell("cargo run", false),                 desc = "Run and keep open" },
    { "<leader>rt", shell("cargo test", false),                desc = "Test" },
    { "<leader>rb", shell("cargo bench", false),               desc = "Bench" },
    { "<leader>rC", Cmd("RustLsp openCargo"),                  desc = "Open Cargo.toml" },
    { "<leader>rm", Cmd("RustLsp expandMacro"),                desc = "Expand macro" },
    { "<leader>rF", require("crates").show_features_popup,     desc = "Show features" },
    { "<leader>rD", require("crates").show_dependencies_popup, desc = "Show dependencies" },
    { "<leader>ra", cargo_add,                                 desc = "Cargo add" },

    { "<leader>s", name = "sic" },
    { "<leader>si", shell("cargo sic inspect", false),                desc = "Inspect" },
    { "<leader>sd", shell("cargo sic dev", false),                    desc = "Develop" },
    { "<leader>sD", shell("cargo sic dev --dfu", false),              desc = "Develop (dfu)" },
    { "<leader>sr", shell("cargo sic dev --release", false),          desc = "Develop (release)" },
    { "<leader>sR", shell("cargo sic dev --release --dfu", false),    desc = "Develop (release, dfu)" },
    { "<leader>sh", shell("cargo sic dev --hwtest", false),           desc = "Develop (hwtest)" },
    { "<leader>sH", shell("cargo sic dev --hwtest --release", false), desc = "Develop (hwtest, release)" },
    { "<leader>sa", shell("cargo sic attach --reset", false),         desc = "Attach" },
    { "<leader>sA", shell("cargo sic attach", false),                 desc = "Attach (no reset)" },
    { "<leader>sc", shell("cargo sic config-builder", false),         desc = "Config builder" },
    { "<leader>sm", shell("cargo sic monitor", false),                desc = "Monitor traffic" },
    { "<leader>se", group = "env" },
    { "<leader>ses", shell("cargo sic env status", false),           desc = "Status" },
    { "<leader>seS", shell("cargo sic env status --details", false), desc = "Status (details)" },
    { "<leader>sel", shell("cargo sic env list", false),             desc = "List" },

    { "<leader>t", group = "toggle" },
    { "<leader>tc", toggle_copilot,   desc = "Toggle Copilot" },
    { "<leader>tw", Cmd("set wrap!"), desc = "Toggle text wrap" },
    { "<leader>tv", toggle_venn,      desc = "Toggle Venn mode" },

    { "<leader>T", group = "telescope" },
    { "<leader>TT", telescope.builtin,                   desc = "Telescope pickers" },
    { "<leader>TA", telescope.autocommands,              desc = "Autocommands" },
    { "<leader>Tb", telescope.current_buffer_fuzzy_find, desc = "Current buffer" },
    { "<leader>TB", telescope.buffers,                   desc = "Buffers" },
    { "<leader>Tc", telescope.loclist,                   desc = "Location list" },
    { "<leader>TC", telescope.commands,                  desc = "Plugin/user commands" },
    { "<leader>Tf", telescope.git_files,                 desc = "Find git files" },
    { "<leader>TH", telescope.highlights,                desc = "Highlights" },
    { "<leader>TM", telescope.man_pages,                 desc = "Man pages" },
    { "<leader>To", telescope.vim_options,               desc = "Vim options" },
    { "<leader>TP", telescope.planets,                   desc = "Use the telescope..." },
    { "<leader>Tq", telescope.quickfix,                  desc = "Quickfix" },
    { "<leader>Tr", telescope.oldfiles,                  desc = "Recent files" },
    { "<leader>Tt", telescope.colorscheme,               desc = "Colorschemes" },
    { "<leader>T'", telescope.marks,                     desc = "Marks" },
    { '<leader>T"', telescope.registers,                 desc = "Registers" },
    { "<leader>T:", telescope.command_history,           desc = "Command history" },
    { "<leader>T/", telescope.search_history,            desc = "Search history" },
    { "<leader>T?", telescope.help_tags,                 desc = "Help tags" },
    { "<leader>T.", telescope.resume,                    desc = "Resume last picker" },
    { "<leader>TF", with_opts(telescope.find_files, { hidden = true }), desc = "Find all files" },

    { "<leader><Tab>", group = "tabular" },
    { "<leader><Tab>=", Cmd("Tabularize /^[^=]*\\zs="), desc = "=" },
    { "<leader><Tab><", Cmd("Tabularize /<-"), desc = "<-" },
    { "<leader><Tab>>", Cmd("Tabularize /->"), desc = "->" },
    { '<leader><Tab>"', Cmd('Tabularize /"'), desc = '"'},
    { "<leader><Tab>:", Cmd("Tabularize /:\\zs/l0r1"), desc = ":"},
    { "<leader><Tab>,", Cmd("Tabularize /,\\zs/l0r1"), desc = ","},
    { "<leader><Tab>1", group = "once" },
    { "<leader><Tab>1:", Cmd("Tabularize /^[^:]*:\\zs/l0r1"), desc = ":"},
    { "<leader><Tab>1,", Cmd("Tabularize /^[^,]*,\\zs/l0r1"), desc = ","},

    { "<leader>w", group = "window" },
    { "<leader>wS", Cmd("Neotree document_symbols"), desc = "Document symbols" },
    { "<leader>wQ", Cmd("qa"), desc = "Close all windows" },
    { "<leader>wt", Cmd("Neotree"), desc = "Toggle tree" },
    { "<leader>wT", Cmd("Neotree reveal"), desc = "Reveal file in tree" },

    { "<leader>K", vim.diagnostic.open_float, desc = "Show diagnostic details" },

    { "<leader>>", "!ipLANG=C sort<CR>", desc = "Sort paragraph" },
    { "<leader><", "!ipLANG=C sort -r<CR>", desc = "Sort paragraph (reverse)" },

    { "[", group = "previous" },
    { "[e", vim.diagnostic.goto_prev, desc = "Previous error" },
    { "[h", Cmd("Gitsigns prev_hunk"), desc = "Previous hunk" },
    { "[q", Cmd("cprev"), desc = "Previous quickfix" },
    { "[l", Cmd("lprev"), desc = "Previous location" },

    { "]", group = "next" },
    { "]e", vim.diagnostic.goto_next, desc = "Next error" },
    { "]h", Cmd("Gitsigns next_hunk"), desc = "Next hunk" },
    { "]q", Cmd("cnext"), desc = "Next quickfix" },
    { "]l", Cmd("lnext"), desc = "Next location" },

    { "<Enter>", Cmd("b#"), desc = "Last buffer" },

    { "<C-'>", Cmd("ToggleTerm"), desc = "Toggle terminal", mode = { "n", "t" } },

    { "'", function()
        vim.system(
            { "kitty", "--directory", vim.fn.getcwd() },
            { detach = true }
        )
    end, desc = "Toggle terminal" },
}
