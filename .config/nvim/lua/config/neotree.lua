vim.g.neo_tree_remove_legacy_commands = true

require("neo-tree").setup {
    sources = {
        "filesystem",
        "git_status",
        "document_symbols",
    },
    window = {
        mappings = {
            ["<leader>wt"] = "close_window",
            ["E"] = "expand_all_nodes",
        }
    },
    default_component_configs = {
        indent = {
            -- indent_marker = "├",
        },
        icon = {
            default = "",
            folder_empty = "󰜌",
            folder_empty_open = "󰜌",
        },
        git_status = {
            symbols = {
                renamed   = "󰁕",
                unstaged  = "",
                modified  = "",
            },
        },
    },
    filesystem = {
        filtered_items = {
            visible = true,
            hide_dotfiles = false,
            always_show = {
                ".cargo",
                ".github",
                ".gitea",
            },
            hide_by_name = {
                "__generated__",
                ".git",
            },
            hide_by_pattern = {
                "*.g.dart",
                "*.freezed.dart",
            },
        },
    },
    document_symbols = {
        kinds = {
            File = { icon = "󰈙", hl = "Tag" },
            Namespace = { icon = "󰌗", hl = "Include" },
            Package = { icon = "󰏖", hl = "Label" },
            Class = { icon = "󰌗", hl = "Include" },
            Property = { icon = "󰆧", hl = "@property" },
            Enum = { icon = "󰒻", hl = "@number" },
            Function = { icon = "󰊕", hl = "Function" },
            String = { icon = "󰀬", hl = "String" },
            Number = { icon = "󰎠", hl = "Number" },
            Array = { icon = "󰅪", hl = "Type" },
            Object = { icon = "󰅩", hl = "Type" },
            Key = { icon = "󰌋", hl = "" },
            Struct = { icon = "󰌗", hl = "Type" },
            Operator = { icon = "󰆕", hl = "Operator" },
            TypeParameter = { icon = "󰊄", hl = "Type" },
            StaticMethod = { icon = '󰠄 ', hl = 'Function' },
        }
    },
}
