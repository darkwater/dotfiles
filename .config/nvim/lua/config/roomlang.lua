if vim.fn.isdirectory(vim.fn.expand("~/github/darkwater/roomlang")) == 0 then
    return
end

require("nvim-treesitter.parsers").get_parser_configs().roomlang = {
    install_info = {
        url = vim.fn.expand("~/github/darkwater/roomlang/grammar"),
        files = { "src/parser.c" },
    },
    filetype = "roomlang",
}

vim.cmd("autocmd BufNewFile,BufRead *.rl setf roomlang")
