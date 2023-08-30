require("ayu").setup {
    mirage = true,
    overrides = {
        Normal = { bg = "NONE" },
        NormalFloat = { bg = "#333844" },
        SignColumn = { bg = "NONE" },
        WinSeparator = { fg = "#606873" },
        WhichKeyFloat = { bg = "NONE" },
        Visual = { fg = "#e0e0e0", bg = "#606873" },
        LineNr = { fg = "#606873" },
        SpecialKey = { fg = "#aaafff" },
        FidgetTitle = { fg = "#ffaf00", bg = "NONE" },
        FidgetTask = { fg = "#00afff", bg = "NONE" },
    },
}

vim.cmd[[
colorscheme ayu
hi link StorageClass Keyword
hi link NeoTreeFileIcon Normal
]]
