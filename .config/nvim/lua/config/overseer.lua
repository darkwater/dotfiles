require("overseer").setup {
    task_list = {
        direction = "right",
    },
    log = {
        {
            type = "notify",
            level = vim.log.levels.INFO,
        },
    },
}
