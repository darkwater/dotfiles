local lsp = require("lspconfig")
-- local lsp_status = require("lsp-status")

local null_ls = require('null-ls')
local jira = require("config.jira")
null_ls.setup {
    sources = {
        jira.completion,
        jira.hover,
        jira.actions,
    },
}

require("pest-vim").setup {}

vim.diagnostic.config {
    virtual_text = true,
    severity_sort = true,
    float = { source = "if_many" },
}

lsp.denols.setup {
    root_dir = lsp.util.root_pattern("deno.json"),
}

lsp.slint_lsp.setup {}
vim.cmd [[ autocmd BufRead,BufNewFile *.slint set filetype=slint ]]
