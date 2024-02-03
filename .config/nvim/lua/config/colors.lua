local neovide = vim.g.neovide

require("ayu").setup {
    mirage = true,
    overrides = {
        Normal = { bg = neovide and "#1f2430" or "NONE" },
        NormalFloat = { bg = "#333844" },
        SignColumn = { bg = "NONE" },
        WinSeparator = { fg = "#606873" },
        WhichKeyFloat = { bg = "NONE" },
        Visual = { fg = "#e0e0e0", bg = "#606873" },
        LineNr = { fg = "#606873" },
        SpecialKey = { fg = "#aaafff" },
        FidgetTitle = { fg = "#ffaf00", bg = "NONE" },
        FidgetTask = { fg = "#00afff", bg = "NONE" },
        DiffAdd = { fg = "#87d96c", bg = "NONE" },
        DiffDelete = { fg = "#f27983", bg = "NONE" },
        DiffChange = { fg = "#80bfff", bg = "NONE" },
        CurSearch = { bg = "#695380" },
        Search = { bg = "#423a56" },
        NoiceVirtualText = { fg = "#606873" },
        Visual = { bg = "#37486d" },
    },
}

vim.cmd[[
colorscheme ayu
hi link StorageClass Keyword
hi link NeoTreeFileIcon Normal
]]
