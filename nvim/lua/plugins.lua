local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        cmd = { "TSUpdateSync" },
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "python", "markdown", "markdown_inline", "bash", "csv", "dockerfile", "json", "rust", "javascript", "typescript", "tsx", "html", "css", "json" },
                auto_install = true,
                highlight = { enable = true, additional_vim_regex_highlighting = false },
                indent = { enable = true },
                modules = {},
                sync_install = false,
                ignore_install = {},
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<Leader>ss",
                        node_incremental = "<Leader>si",
                        node_decremental = "<Leader>sd",
                    },
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = { query = "class.inner", desc = "Select inner part of a class region" },
                        },
                        selection_modes = {
                            ["@parameter.outer"] = "v",
                            ["@function.outer"] = "v",
                            ["@class.outer"] = "<c-v>",
                        },
                        include_surrounding_whitespace = false,
                    },
                },
                refactor = {
                    highlight_definitions = {
                        enable = true,
                        clear_on_cursor_move = true,
                    },
                },
            })
        end,
        -- lockfile = false, -- Add this line to disable the lockfile
    },
    {
        "nvim-lua/plenary.nvim",
        lazy = true,
    },
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        event = 'VeryLazy',
        dependencies = {
            "nvim-lua/plenary.nvim",
            "joshmedeski/telescope-smart-goto.nvim",
            "ThePrimeagen/harpoon",
        },
        config = function()
        end,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        lazy = true,
        config = function()
            vim.cmd.colorscheme "catppuccin"
        end,
        init = function()
            -- Load immediately after startup
            vim.cmd.colorscheme "catppuccin"
        end,
    },

    { "MunifTanjim/nui.nvim",                        lazy = true },
    { "nvim-treesitter/nvim-treesitter-refactor",    event = "VeryLazy" },
    { "nvim-treesitter/nvim-treesitter-textobjects", event = "VeryLazy" },
    { "nvim-treesitter/nvim-treesitter-context",     event = "VeryLazy" },
    {
        'neovim/nvim-lspconfig',
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            require("plugins.lsp").setup()
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "rafamadriz/friendly-snippets",
        },
        config = function()
            require("plugins.cmp").setup()
        end,
    },
    {
        "williamboman/mason.nvim",
        lazy = false,   -- Load during startup
        priority = 100, -- Load early
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        event = "BufReadPre",
        dependencies = { "mason.nvim" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "bashls",
                    "sqlls",
                }
            })
        end,
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        config = function()
            require("plugins.noice")
        end,
        keys = {
            { "<leader>nh", ":Noice<CR>", desc = "Noice History" }
        }
    },
    {
        "christoomey/vim-tmux-navigator", event = "VeryLazy"
    },
    {
        "nvim-tree/nvim-web-devicons", lazy = true
    },
    {
        "folke/trouble.nvim",
        cmd = { "TroubleToggle", "Trouble" },
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            require("plugins.trouble").setup()
        end,
    },
    {
        "ggandor/leap.nvim",
        keys = {
            { "s",  mode = { "n", "x", "o" }, desc = "Leap forward to" },
            { "S",  mode = { "n", "x", "o" }, desc = "Leap backward to" },
            { "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
        },
        config = function()
            local leap = require("leap")
            leap.add_default_mappings()
            leap.opts.case_sensitive = true
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("plugins.gitsigns")
        end,
    },
    {
        "xiyaowong/telescope-emoji.nvim", event = "VeryLazy"
    },
    {
        "epwalsh/obsidian.nvim",
        version = "*",
        ft = "markdown",
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
        config = function()
            require("plugins.obsidian").setup()
        end,
    },
    {
        "lambdalisue/suda.vim",
        event = "VeryLazy",
        config = function()
            vim.g.suda_smart_edit = 1 -- Optional: enables smart edit
            -- You can put your keybinding here if you prefer
            vim.keymap.set("n", "<leader>W", ":SudaWrite<CR>", { silent = true })
        end,
    },
    {
        "AckslD/nvim-neoclip.lua",
        dependencies = {
            'kkharji/sqlite.lua',
            'nvim-telescope/telescope.nvim',
            'nvim-lua/plenary.nvim',
        },
        event = "VeryLazy",
        config = function()
            require("plugins.neoclip")
        end,
    },
    {
        "yetone/avante.nvim",
        event = "VeryLazy",
        lazy = false,
        version = false, -- set this if you want to always pull the latest change
        opts = {
            windows = {
                ---@type "right" | "left" | "top" | "bottom"
                position = "right",   -- the position of the sidebar
                wrap = true,          -- similar to vim.o.wrap
                width = 40,           -- default % based on available width
                sidebar_header = {
                    enabled = true,   -- true, false to enable/disable the header
                    align = "center", -- left, center, right for title
                    rounded = true,
                },
            },
        },
        -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
        build = "make",
        -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
        dependencies = {
            "stevearc/dressing.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            --- The below dependencies are optional,
            "hrsh7th/nvim-cmp",       -- autocompletion for avante commands and mentions
            "echasnovski/mini.icons", -- or echasnovski/mini.icons
            -- "zbirenbaum/copilot.lua", -- for providers='copilot'
            {
                -- support for image pasting
                "HakonHarnes/img-clip.nvim",
                event = "VeryLazy",
                opts = {
                    -- recommended settings
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {
                            insert_mode = true,
                        },
                        -- required for Windows users
                        -- use_absolute_path = true,
                    },
                },
            },
            {
                -- Make sure to set this up properly if you have lazy=true
                'MeanderingProgrammer/render-markdown.nvim',
                opts = {
                    file_types = { "markdown", "Avante" },
                },
                ft = { "markdown", "Avante" },
            },
        },
    },
    {
        'stevearc/oil.nvim',
        ---@module 'oil'
        opts = {
            view_options = {
                -- Enable showing hidden files
                show_hidden = true,
                -- Define what is considered a "hidden" file
                is_hidden_file = function(name, bufnr)
                    -- Match files that start with "."
                    return name:match("^%.") ~= nil
                end,
            },
        },
        config = function(_, opts)
            require("oil").setup(opts)
            vim.keymap.set("n", "<leader>tt", require("oil").open, { desc = "Open Oil file browser" })
        end,
        dependencies = { { "echasnovski/mini.icons", opts = {} } },
    },
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        config = function()
            require("plugins.snacks").setup()
        end,
    }

})
-- Set conceallevel for Markdown files
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.opt_local.conceallevel = 2
    end,
})
