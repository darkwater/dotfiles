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
