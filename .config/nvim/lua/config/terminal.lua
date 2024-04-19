vim.system(
    { "osqueryi", "--list", "select 1 from connected_displays where name = \"PL3466WQ\";" },
    { text = true },
    function(obj)
        local ultrawide_connected = false

        if obj.code == 0 and obj.stdout == "1\n1\n" then
            ultrawide_connected = true
        end

        vim.schedule(function()
            print("ultrawide_connected", ultrawide_connected)
            require("toggleterm").setup {
                direction = "vertical",
                size = ultrawide_connected and 120 or 80,
            }
        end)
    end
)
