local cmp = require("cmp")

local colorful = require("colorful-menu")
colorful.setup {
    ls = {
        ["rust-analyzer"] = {
            align_type_to_right = false,
        },
    },
    max_width = 60,
}

require("nvim-web-devicons").setup {
    default = true,
}

cmp.setup {
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
        { name = "nvim_lua" },
        { name = "snippy" },
        { name = "crates" },
    }),
    snippet = {
        expand = function(args)
            -- require('luasnip').lsp_expand(args.body)
            require("snippy").expand_snippet(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-y>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        }),
        -- ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
        -- ["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
    }),
    window = {
        completion = {
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
            col_offset = -3,
            side_padding = 1,
        },
    },
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            local highlights_info = colorful.cmp_highlights(entry)

            if highlights_info ~= nil then
                vim_item.abbr_hl_group = highlights_info.highlights
                vim_item.abbr = highlights_info.text
            end

            -- vim_item.kind = ""
            -- vim_item.kind_hl_group = ""

            if vim.tbl_contains({ 'path' }, entry.source.name) then
                print(entry:get_completion_item().label)
                local icon, hl_group = require('nvim-web-devicons').get_icon(entry:get_completion_item().label)
                if icon then
                    vim_item.kind = icon
                    vim_item.kind_hl_group = hl_group
                end
            end

            vim_item.menu = ""
            vim_item.menu_hl_group = ""

            local vim_item = require('lspkind').cmp_format{ mode = "symbol" }(entry, vim_item)

            vim_item.kind = vim_item.kind .. " "

            return vim_item

            -- local item = entry:get_completion_item()
            -- if item.data ~= nil and item.data.jira_issue then
            --     local map = {
            --         ["Done"] = "@constant",
            --         ["Closed"] = "@constant",
            --         ["In Progress"] = "@property",
            --         ["Todo"] = "@string",
            --         ["Ready for preparation Client"] = "@comment",
            --     }

            --     vim_item.kind = item.data.status
            --     vim_item.kind_hl_group = map[item.data.status] or "@function"
            --     return vim_item
            -- end

            -- return require('lspkind').cmp_format{ with_text = false }(entry, vim_item)
        end,
    },
}
