require("neotest").setup {
    adapters = {
        require("rustaceanvim.neotest")
    },
    output = { enabled = false },
    status = {
        signs = false,
        virtual_text = true,
    },
}
