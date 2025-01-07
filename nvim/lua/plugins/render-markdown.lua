return {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    config = function()
        require("render-markdown").setup({
            -- Default settings
            glow_path = "glow",
            width = 100,
        })

    end,
    -- Load only for markdown files
    ft = { "markdown" },
}
