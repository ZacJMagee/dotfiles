return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-project.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
        },
    },
    cmd = "Telescope",
    keys = {
        { "<Leader>ff", function() require('telescope.builtin').find_files() end,                desc = "Find Files" },
        { "<Leader>fg", function() require('telescope.builtin').live_grep() end,                 desc = "Live Grep" },
        { "<Leader>fh", function() require('telescope.builtin').help_tags() end,                 desc = "Help Tags" },
        { "<Leader>/",  function() require('telescope.builtin').current_buffer_fuzzy_find() end, desc = "Fuzzy Search Buffer" },
        { "<Leader>fp", function() require('telescope').extensions.project.project({}) end,      desc = "Projects" },
    },
    opts = {
        defaults = {
            prompt_prefix = "🔍 ",
            selection_caret = "➤ ",
            layout_strategy = "flex",
            layout_config = {
                width = 0.85,
                height = 0.8,
                preview_cutoff = 120,
                prompt_position = "top",
            },
            sorting_strategy = "ascending",
            borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
            file_ignore_patterns = { "node_modules", ".git/" },
            mappings = {
                i = {
                    ["<C-j>"] = require("telescope.actions").move_selection_next,
                    ["<C-k>"] = require("telescope.actions").move_selection_previous,
                    ["<esc>"] = require("telescope.actions").close,
                },
            },
        },
        pickers = {
            find_files = {
                layout_strategy = "vertical",
                layout_config = {
                    width = 0.5,
                    height = 0.7,
                    prompt_position = "bottom",
                },
                hidden = true,
                previewer = false,
            },
            buffers = {
                theme = "dropdown",
                previewer = false,
            },
            live_grep = {
                theme = "ivy",
            },
        },
        extensions = {
            fzf = {
                fuzzy = true,
                override_generic_sorter = true,
                override_file_sorter = true,
                case_mode = "smart_case",
            },
            project = {
                base_dirs = { "~/dev" },
                hidden_files = true,
            },
        },
    },
    config = function(_, opts)
        local telescope = require("telescope")
        telescope.setup(opts)

        -- Safely load extensions
        pcall(telescope.load_extension, "fzf")
        pcall(telescope.load_extension, "project")
    end,
}
