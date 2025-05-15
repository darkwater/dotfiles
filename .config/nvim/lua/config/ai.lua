-- require("codecompanion").setup {
--     strategies = {
--         chat = {
--             adapter = "copilot",
--         },
--         inline = {
--             adapter = "copilot",
--         },
--     },
-- }

require("CopilotChat").setup {
    mappings = {
        submit_prompt = {
            normal = "<C-CR>",
            insert = "<C-CR>",
        },
    },
}
