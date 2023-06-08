require("nvim-treesitter.configs").setup {
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "org" },
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["am"] = "@function.outer",
                ["im"] = "@function.inner",
                ["al"] = "@class.outer",
                -- You can optionally set descriptions to the mappings (used in the desc parameter of
                -- nvim_buf_set_keymap) which plugins like which-key display
                ["il"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                ["ab"] = "@block.outer",
                ["ib"] = "@block.inner",
                ["ad"] = "@conditional.outer",
                ["id"] = "@conditional.inner",
                ["ao"] = "@loop.outer",
                ["io"] = "@loop.inner",
                ["aa"] = "@parameter.outer",
                ["ia"] = "@parameter.inner",
                ["af"] = "@call.outer",
                ["if"] = "@call.inner",
                ["ac"] = "@comment.outer",
                ["ar"] = "@frame.outer",
                ["ir"] = "@frame.inner",
                ["at"] = "@attribute.outer",
                ["it"] = "@attribute.inner",
                ["ae"] = "@scopename.inner",
                ["ie"] = "@scopename.inner",
                ["as"] = "@statement.outer",
                ["is"] = "@statement.outer",
            },
            selection_modes = {
                ['@parameter.outer'] = 'v',
                ['@statement.outer'] = 'V',
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ["<leader>ma"] = "@parameter.inner",
                ["<leader>me"] = "@statement.outer",
            },
            swap_previous = {
                ["<leader>mA"] = "@parameter.inner",
                ["<leader>mE"] = "@statement.outer",
            },

        },
        move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
                ["]m"] = "@function.outer",
                ["]]"] = "@class.outer",
            },
            goto_next_end = {
                ["]M"] = "@function.outer",
                ["]["] = "@class.outer",
            },
            goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[["] = "@class.outer",
            },
            goto_previous_end = {
                ["[M"] = "@function.outer",
                ["[]"] = "@class.outer",
            },
        },
        lsp_interop = {
            enable = true,
            peek_definition_code = {
                ["<leader>df"] = "@function.outer",
                ["<leader>dF"] = "@class.outer",
            },
        },
    },
    ensure_installed = { "org", "python", "lua", "bash", "json", "yaml", "toml", "html", "css", "javascript", "typescript", "cpp", "rust", "go", "dart", "java", "regex", "comment" },
}
