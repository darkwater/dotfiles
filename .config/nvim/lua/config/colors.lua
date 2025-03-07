local neovide = vim.g.neovide or (vim.env.NEOVIDE_REMOTE == "1")

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
        -- DiffAdd = { fg = "#87d96c", bg = "NONE" },
        -- DiffChange = { fg = "#80bfff", bg = "NONE" },
        DiffDelete = { fg = "#405060", bg = "NONE" },
        DiffText = { bg = "#304873" },
        -- CurSearch = { bg = "#695380" },
        -- Search = { bg = "#423a56" },
        NoiceVirtualText = { fg = "#606873" },
        Visual = { bg = "#37486d" },
        JiraTodo = { fg = "#d5ff80", bg = "#172b4d" },
        JiraDone = { fg = "#dfbfff", bg = "#172b4d" },
        CratesNvimPopupPillText = { fg = "#e0e0e0", bg = "#806010" },
        CratesNvimPopupPillBorder = { fg = "#806010" },
        CmpSelection = { bg = "#606873" },
        -- OL1 = { fg = "#409fff" },
        -- OL2 = { fg = "#4e99e5" },
        -- OL3 = { fg = "#5791cc" },
        -- OL4 = { fg = "#5c87b2" },
        -- OL5 = { fg = "#5d7b99" },
        -- OL6 = { fg = "#5d7b99" },
        -- OL7 = { fg = "#5d7b99" },
        -- OL8 = { fg = "#5d7b99" },
        -- OL9 = { fg = "#5d7b99" },
    },
}

vim.cmd [[
colorscheme ayu
hi link StorageClass Keyword
hi link NeoTreeFileIcon Normal
hi link @lsp.type.keyword Keyword
hi link @lsp.type.string String
hi link @lsp.type.number Number
hi link @lsp.type.operator Operator
hi link LspInlayHint Comment
hi link JiraInProgress JiraTodo
hi link JiraReadyForReview JiraInProgress
hi link JiraInReview JiraInProgress
hi link JiraReadyForTest JiraInProgress
hi link JiraInTest JiraInProgress
hi link JiraReleased JiraDone
hi link JiraClosed JiraDone
hi link CratesNvimVersion Comment
]]
