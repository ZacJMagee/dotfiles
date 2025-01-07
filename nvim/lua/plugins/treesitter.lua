return {
    { "MunifTanjim/nui.nvim",                        lazy = true },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        cmd = { "TSUpdateSync" },
        config = function()
            require("nvim-treesitter.configs").setup({
                highlight = { enable = true },
                indent = { enable = true },
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
        lockfile = false, -- Disable the lockfile
    },
    { "nvim-treesitter/nvim-treesitter-refactor",    event = "VeryLazy" },
    { "nvim-treesitter/nvim-treesitter-textobjects", event = "VeryLazy" },
    { "nvim-treesitter/nvim-treesitter-context",     event = "VeryLazy" },
}
