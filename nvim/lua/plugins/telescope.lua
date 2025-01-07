return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "AckslD/nvim-neoclip.lua",
        },
        config = function()
            local telescope = require("telescope")
            local keybindings = require("keybindings").setup_telescope_keybindings()

            telescope.setup({
                defaults = {
                    mappings = keybindings, -- Load the keybindings
                    file_ignore_patterns = {
                        "%.egg%-info/.*",
                        "%.eggs/.*",
                        "%.pyc",
                        "__pycache__/*",
                        "%.pytest_cache/.*",
                        "node_modules/*",
                        ".cache/*",
                        "target/.*", -- Add Rust target directory
                    },
                    vimgrep_arguments = {
                        "rg",
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                        "--smart-case",
                        "--hidden",       -- Include hidden files
                        "--glob=!.git/*", -- Exclude .git folder
                        "--no-ignore-vcs",
                    },
                },
                pickers = {
                    find_files = {
                        hidden = true,     -- Show hidden files
                        no_ignore = true,  -- Ignore .gitignore rules
                        find_command = {
                            "fd",          -- Use fd for better performance
                            "--type", "f", -- Only list files
                            "--hidden",    -- Include hidden files
                            "--no-ignore", -- Include ignored files
                        },
                    },
                    live_grep = {
                        additional_args = function()
                            return {
                                "--hidden",             -- Include hidden files
                                "--no-ignore",          -- Don't ignore files listed in .gitignore
                                "--glob", "!**/.git/*", -- Exclude .git folder
                            }
                        end,
                    },
                },
                extensions = {
                    undo = {
                        use_delta = true,
                        side_by_side = false,
                        vim_diff_opts = { ctxlen = 999 },
                        entry_format = "state #$ID, $STAT, $TIME",
                        mappings = keybindings.i, -- Include undo-specific keybindings
                    },
                    neoclip = {
                        history = 1000,
                        enable_persistent_history = true,
                        continuous_sync = true,
                        db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
                        filter = nil,
                        preview = true,
                        default_register = '"',
                        default_register_macros = 'q',
                        enable_macro_history = true,
                        content_spec_column = false,
                        on_paste = {
                            set_reg = false,
                            move_to_front = false,
                            close_telescope = true,
                        },
                        on_replay = {
                            set_reg = false,
                            move_to_front = false,
                            close_telescope = true,
                        },
                        keys = {
                            i = {
                                select = '<cr>',
                                paste = '<c-p>',
                                paste_behind = '<c-k>',
                                replay = '<c-q>',
                                delete = '<c-d>',
                                edit = '<c-e>',
                                custom = {},
                            },
                            n = {
                                select = '<cr>',
                                paste = 'p',
                                paste_behind = 'P',
                                replay = 'q',
                                delete = 'd',
                                edit = 'e',
                                custom = {},
                            },
                        },
                    },
                },
            })

            local extensions = {
                "undo",
                "fzf",
                "live_grep_args",
            }

            for _, ext in ipairs(extensions) do
                pcall(telescope.load_extension, ext)
            end
        end,
    },
    -- Quickfix for Workspace Errors (Auto-Opens Quickfix)
vim.api.nvim_create_user_command('QuickfixLspWorkspace', function()
  -- Populate Quickfix List with workspace-wide LSP errors
  vim.diagnostic.setqflist({ scope = "workspace" })

  -- Open Quickfix window
  vim.cmd("copen")
end, {}),

-- Quickfix for File Errors (Auto-Opens Quickfix)
vim.api.nvim_create_user_command('QuickfixLspFile', function()
  -- Populate Quickfix List with file-specific LSP errors
  vim.diagnostic.setqflist({ scope = "buffer" }) -- Current buffer

  -- Open Quickfix window
  vim.cmd("copen")
end, {}),

-- Keybindings
vim.api.nvim_set_keymap('n', '<leader>tw', '<cmd>QuickfixLspWorkspace<CR>', { noremap = true, silent = true }), -- Workspace
vim.api.nvim_set_keymap('n', '<leader>qf', '<cmd>QuickfixLspFile<CR>', { noremap = true, silent = true })      -- File


}
