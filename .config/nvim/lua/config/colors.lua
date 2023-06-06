require("ayu").setup {
    mirage = true,
    overrides = {
        Normal = { bg = "NONE" },
        NormalFloat = { bg = "#333844" },
    },
}

vim.cmd[[
colorscheme ayu
hi link StorageClass Keyword
hi link NeoTreeFileIcon Normal
]]
