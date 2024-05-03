require("toggleterm").setup {
    direction = "vertical",
    size = vim.o.columns > 280 and 120 or 80,
}
