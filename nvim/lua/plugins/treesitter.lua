return {
	{ -- Main Treesitter plugin
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			ensure_installed = {
				"lua",
				"vim",
				"bash",
				"python",
				"javascript",
				"typescript",
				"html",
				"css",
			},
			sync_install = false,
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<Enter>",
					node_incremental = "<Enter>",
					scope_incremental = false,
					node_decremental = "<Backspace>",
				},
			},
			indent = {
				enable = false,
			},
			refactor = {
				highlight_definitions = {
					enable = false,
					clear_on_cursor_move = true,
				},
				highlight_current_scope = {
					enable = false,
				},
				-- smart_rename = {
				--     enable = true,
				--     keymaps = {
				--         smart_rename = "grr",
				--     },
				-- },
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
						["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
					},
					selection_modes = {
						["@parameter.outer"] = "v", -- charwise
						["@function.outer"] = "V", -- linewise
						["@class.outer"] = "<c-v>", -- blockwise
					},
					include_surrounding_whitespace = false,
				},
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},

	{ -- Treesitter Context
		"nvim-treesitter/nvim-treesitter-context",
		event = "VeryLazy",
		opts = {
			enable = true,
			multiwindow = false,
			max_lines = 0,
			min_window_height = 0,
			line_numbers = true,
			multiline_threshold = 20,
			trim_scope = "outer",
			mode = "cursor",
			separator = nil,
			zindex = 20,
			on_attach = nil,
		},
		config = function(_, opts)
			require("treesitter-context").setup(opts)
		end,
	},

	{ -- Treesitter Refactor
		"nvim-treesitter/nvim-treesitter-refactor",
		event = "VeryLazy",
		config = false, -- Handled by main treesitter setup
	},

	{ -- Treesitter Textobjects
		"nvim-treesitter/nvim-treesitter-textobjects",
		event = "VeryLazy",
		config = false, -- Handled by main treesitter setup
	},

	{ -- Playground
		"nvim-treesitter/playground",
		cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
		config = false, -- No config needed
	},
}
