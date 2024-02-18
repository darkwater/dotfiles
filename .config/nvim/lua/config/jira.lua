local null_ls = require('null-ls')
local M = {}

vim.api.nvim_create_augroup("Jira", { clear = true })
vim.api.nvim_create_autocmd("BufWrite", {
    group = "Jira",
    pattern = "*.otl",
    callback = function(args)
        local ns = vim.api.nvim_create_namespace("jira")
        vim.api.nvim_buf_clear_namespace(args.buf, ns, 0, -1)

        local issues = {}
        local f = io.open(os.getenv("HOME") .. "/.jira/issues.txt", "r")
        if f then
            for line in f:lines() do
                local fields = {}
                for field in line:gmatch("[^\t]+") do
                    table.insert(fields, field)
                end
                local kind = fields[1]
                local id = fields[2]
                local summary = fields[3]
                local status = fields[4]
                local priority = fields[5]
                local assignee = fields[6] or "-"

                issues[id] = status
            end
            f:close()
        end

        local states = {
            ["Ready for preparation Client"] = "JiraTodo",
            ["Todo"]                         = "JiraTodo",
            ["In Progress"]                  = "JiraInProgress",
            ["Ready for review"]             = "JiraReadyForReview",
            ["In review"]                    = "JiraInReview",
            ["Ready for test"]               = "JiraReadyForTest",
            ["In test"]                      = "JiraInTest",
            ["Done"]                         = "JiraDone",
            ["Released"]                     = "JiraReleased",
            ["Closed"]                       = "JiraClosed",
        }

        local lines = vim.api.nvim_buf_get_lines(args.buf, 0, -1, false)
        for linenr, line in ipairs(lines) do
            -- for match in line:gmatch("SIC%-[0-9]+") do
            local start = 0
            while true do
                local startpos, endpos = string.find(line, "SIC%-[0-9]+", start, false)
                if not startpos then break end
                start = endpos
                local issue = string.sub(line, startpos, endpos)
                if issues[issue] and states[issues[issue]] then
                    vim.api.nvim_buf_set_extmark(
                        vim.fn.bufnr("%"),
                        vim.api.nvim_create_namespace("jira"),
                        linenr - 1,
                        startpos - 1,
                        {
                            end_col = endpos,
                            hl_group = states[issues[issue]],
                        }
                    )
                    vim.api.nvim_buf_set_extmark(
                        vim.fn.bufnr("%"),
                        vim.api.nvim_create_namespace("jira"),
                        linenr - 1,
                        endpos,
                        {
                            virt_text = {
                                -- { " ", "" },
                                { " " .. issues[issue], states[issues[issue]] },
                            },
                            virt_text_pos = "inline"
                        }
                    )
                end
            end
        end
    end,
})

M.completion = {}
M.completion.name = "jira_completion"
M.completion.method = null_ls.methods.COMPLETION
M.completion.filetypes = {}
M.completion.generator = {
    async = true,
    fn = function(params, done)
        local cword = vim.fn.getline("."):sub(1, vim.fn.col(".") - 1):match("([A-Z]+%-)$")

        if cword ~= "SIC-" then
            done {
                isIncomplete = true,
            }
            return
        end

        -- read lines from ~/.jira/issues.txt
        local issues = {}
        local f = io.open(os.getenv("HOME") .. "/.jira/issues.txt", "r")
        if f then
            for line in f:lines() do
                local fields = {}
                for field in line:gmatch("[^\t]+") do
                    table.insert(fields, field)
                end
                local kind = fields[1]
                local id = fields[2]
                local summary = fields[3]
                local status = fields[4]
                local priority = fields[5]
                local assignee = fields[6] or "-"

                table.insert(issues, {
                    label = id .. "  " .. summary .. " (" .. assignee .. ")",
                    insertText = id .. " " .. summary,
                    documentation = {
                        id .. "  \\[" .. status .. "\\]",
                        "Kind:     " .. kind,
                        "Priority: " .. priority,
                        "Assignee: " .. assignee,
                        "",
                        summary,
                    },
                    data = {
                        jira_issue = true,
                        status = status,
                    },
                })
            end
            f:close()
        end

        -- local s = ""
        -- s = s .. (vim.inspect(5))
        -- s = s .. (vim.inspect(issues))
        -- s = s .. (vim.inspect(10))
        -- vim.notify(s)

        -- return completion items
        done {
            {
                items = issues,
                isIncomplete = false,
            },
        }
    end
}

M.hover = {}
M.hover.name = "jira_hover"
M.hover.method = null_ls.methods.HOVER
M.hover.filetypes = {}
M.hover.generator = {
    async = true,
    fn = function(params, done)
        local cword = vim.fn.expand("<cWORD>"):match("([A-Z]+%-[0-9]+)")

        local f = io.open(os.getenv("HOME") .. "/.jira/issues.txt", "r")
        if f then
            for line in f:lines() do
                local fields = {}
                for field in line:gmatch("[^\t]+") do
                    table.insert(fields, field)
                end
                local id = fields[2]

                if cword == id then
                    local kind = fields[1]
                    local summary = fields[3]
                    local status = fields[4]
                    local priority = fields[5]
                    local assignee = fields[6] or "-"

                    done {
                        id .. "  \\[" .. status .. "\\]",
                        "Kind:     " .. kind,
                        "Priority: " .. priority,
                        "Assignee: " .. assignee,
                        "",
                        summary,
                    }
                    return
                end
            end
        end

        done()
    end
}

M.actions = {}
M.actions.name = "jira_actions"
M.actions.method = null_ls.methods.CODE_ACTION
M.actions.filetypes = {}
M.actions.generator = {
    async = true,
    fn = function(params, done)
        -- read lines from ~/.jira/states.txt
        local states = {}
        local f = io.open(os.getenv("HOME") .. "/.jira/states.txt", "r")
        if f then
            for line in f:lines() do
                local line = line:gsub("\n", "")
                table.insert(states, line)
            end
            f:close()
        end

        local actions = {}

        local issue_ids = vim.fn.getline("."):gmatch("(SIC%-[0-9]+)")

        for id in issue_ids do
            for _, state in ipairs(states) do
                table.insert(actions, {
                    title = id .. ": Move to: " .. state,
                    action = function()
                        vim.fn.jobstart {
                            "jira",
                            "issue",
                            "move",
                            id,
                            state,
                        }

                        vim.fn.jobstart {
                            "sh",
                            "-c",
                            "sleep 10; exec ~/.jira/update.sh",
                        }
                    end,
                })
            end
        end

        -- return completion items
        done(actions)
    end
}

return M
