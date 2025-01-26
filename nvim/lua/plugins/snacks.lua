local M = {}

function M.setup()
    -- Get reference to snacks module - this is our main entry point to all snacks functionality
    local Snacks = require("snacks")

    -- Define theme path - this is where lazygit will store its theme configuration
    -- We use vim.fs.normalize to ensure proper path formatting across different systems
    local lazygit_theme_path = vim.fs.normalize(vim.fn.stdpath("cache") .. "/lazygit-theme.yml")

    -- Core configuration setup
    -- This is where we define all the features and their settings
    Snacks.setup({
        -- Core features - disabled features we don't need to reduce overhead
        bigfile = { enabled = false },   -- Large file optimizations
        dashboard = { enabled = false }, -- Custom dashboard
        indent = { enabled = true },     -- Indentation guides
        input = { enabled = false },     -- Custom input handling

        -- Lazygit integration configuration
        lazygit = {
            configure = true, -- Enable automatic configuration

            -- Command configuration
            cmd = "/run/current-system/sw/bin/lazygit", -- Full path ensures NixOS can find it
            args = {},                                  -- Additional arguments if needed

            -- Environment setup
            env = {
                -- Track directory changes between sessions
                LAZYGIT_NEW_DIR_FILE = vim.fn.stdpath("data") .. "/lazygit-new-dir",
                GIT_EDITOR = "nvim", -- Use neovim for git operations
            },

            -- Theme settings
            theme_path = lazygit_theme_path,
            theme = {
                -- UI element colors mapped to Neovim highlight groups
                [241] = { fg = "Special" },
                activeBorderColor = { fg = "MatchParen", bold = true },
                inactiveBorderColor = { fg = "FloatBorder" },
                searchingActiveBorderColor = { fg = "MatchParen", bold = true },

                -- Git-specific UI elements
                cherryPickedCommitBgColor = { fg = "Identifier" },
                cherryPickedCommitFgColor = { fg = "Function" },
                unstagedChangesColor = { fg = "DiagnosticError" },

                -- General UI theming
                defaultFgColor = { fg = "Normal" },
                optionsTextColor = { fg = "Function" },
                selectedLineBgColor = { bg = "Visual" },
            },

            -- Window display settings
            win = {
                style = "lazygit",
                border = "rounded",
                width = 0.9,  -- 90% of screen width
                height = 0.9, -- 90% of screen height
            },

            -- Additional lazygit configuration
            config = {
                os = {
                    editPreset = "nvim-remote", -- Integration with current Neovim instance
                    editCommand = "nvim"
                },
                gui = {
                    nerdFontsVersion = "3",
                    showIcons = true,
                },
                git = {
                    paging = {
                        colorArg = "always",
                        pager = "delta --dark --paging=never", -- Uses delta for better diff viewing
                    },
                },
            },
        },

        -- Notification system configuration
        notifier = {
            enabled = true,
            timeout = 5000, -- 5 seconds for notifications
        },

        -- Additional features
        quickfile = { enabled = false },    -- Quick file switching
        scroll = { enabled = true },        -- Smooth scrolling
        statuscolumn = { enabled = false }, -- Custom status column
        words = { enabled = false },        -- Word navigation

        -- Style configurations
        styles = {
            notification = {}
        }
    })

    -- Keybinding definitions
    -- Each keybinding is defined with its function and description
    local keys = {
        -- Zen mode and focus
        { "<leader>z",  function() Snacks.zen() end,                     desc = "Toggle Zen Mode" },
        { "<leader>Z",  function() Snacks.zen.zoom() end,                desc = "Toggle Zoom" },

        -- Notifications
        { "<leader>n",  function() Snacks.notifier.show_history() end,   desc = "Notification History" },

        -- Git operations
        { "<leader>gB", function() Snacks.git.blame_line() end,          desc = "Git Blame Line" },
        { "<leader>gf", function() Snacks.lazygit.log_file() end,        desc = "Lazygit Current File History" },
        { "<leader>gg", function() Snacks.lazygit() end,                 desc = "Lazygit" },
        { "<leader>gl", function() Snacks.lazygit.log() end,             desc = "Lazygit Log (cwd)" },

        -- Utility functions
        { "<leader>un", function() Snacks.notifier.hide() end,           desc = "Dismiss All Notifications" },

    }

    -- Special case: Neovim News window configuration
    vim.keymap.set("n", "<leader>N", function()
        Snacks.win({
            file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
            width = 0.6,
            height = 0.6,
            wo = {
                spell = false,
                wrap = false,
                signcolumn = "yes",
                statuscolumn = " ",
                conceallevel = 3,
            },
        })
    end, { desc = "Neovim News" })

    -- Register all keybindings
    for _, mapping in ipairs(keys) do
        vim.keymap.set(mapping.mode or "n", mapping[1], mapping[2], {
            desc = mapping.desc,
        })
    end

    -- Initialize debug features and toggles after lazy loading
    vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
            -- Debug utilities
            _G.dd = function(...) Snacks.debug.inspect(...) end
            _G.bt = function() Snacks.debug.backtrace() end
            vim.print = _G.dd

            -- Toggle mappings for various editor features
            Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
            Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
            Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
            Snacks.toggle.diagnostics():map("<leader>ud")
            Snacks.toggle.line_number():map("<leader>ul")
            Snacks.toggle.option("conceallevel", {
                off = 0,
                on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2
            }):map("<leader>uc")
            Snacks.toggle.treesitter():map("<leader>uT")
            Snacks.toggle.option("background", {
                off = "light",
                on = "dark",
                name = "Dark Background"
            }):map("<leader>ub")
            Snacks.toggle.inlay_hints():map("<leader>uh")
            Snacks.toggle.indent():map("<leader>ug")
            Snacks.toggle.dim():map("<leader>uD")
        end,
    })
end

return M
