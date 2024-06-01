require("telescope").setup {
    defaults = {
        border = false,
        borderchars = {
            -- prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
            -- results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
            prompt = { " " },
            results = { " " },
            -- prompt = { "─", " ", " ", " ", "─", "─", " ", " " },
            -- results = { "─", " ", "─", " ", "─", "─", "─", "─" },
        },
        layout_config = {
            prompt_position = "top",
            -- height = <function 1>,
            -- preview_cutoff = 1,
            -- width = <function 2>,
        },
        layout_strategy = "bottom_pane",
        results_title = false,
        sorting_strategy = "ascending",
        scroll_strategy = "cycle",

        prompt_prefix = "   ",
        selection_caret = " ",
        entry_prefix = " ",

        mappings = {
            i = {
                ["<C-j>"] = require('telescope.actions').move_selection_next,
                ["<C-k>"] = require('telescope.actions').move_selection_previous,
            },
        },

        file_ignore_patterns = {
            "%.g.dart",
        },
    },
    pickers = {
        find_files = {
            previewer = false,
            mappings = {
                i = {
                    -- ["<Esc>"] = require('telescope.actions').close,
                },
            },
        },
    },
}

local M = {}

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local homedir = vim.fn.expand "$HOME"

M.projects = function()
     pickers.new({}, {
        prompt_title = "Projects",
        finder = finders.new_oneshot_job({
            "fd", "--exact-depth", "2", "--type", "directory", ".",
            homedir .. "/gitea", homedir .. "/github"
        }, {
            -- entry_maker = function(line)
            --     return {
            --         value = line,
            --         display = line,
            --         ordinal = line,
            --     }
            -- end,
        }),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                vim.cmd("cd " .. selection.value)
            end)
            return true
        end,
    }):find()
end

return M
