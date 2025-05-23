require("coverage").setup {
    signs = {
        covered   = { hl = "CoverageCovered",   text = "𜱃" },
        uncovered = { hl = "CoverageUncovered", text = "🮘" },
        partial   = { hl = "CoveragePartial",   text = "🮘" },
    },
}
