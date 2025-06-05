return {
	"stevearc/oil.nvim",
	dependencies = {
		{
			"echasnovski/mini.icons",
			opts = {},
		},
	},
	lazy = false, -- Recommended by oil.nvim; avoid lazy-loading
	opts = {
		default_file_explorer = true,

		-- Columns to display in the Oil file browser
		columns = {
			"icon", -- Use devicons or mini.icons
			-- "permissions",
			-- "size",
			-- "mtime",
		},

		-- Buffer-local options specific to Oil buffers
		buf_options = {
			buflisted = false,
			bufhidden = "hide",
		},

		-- Window-local options for Oil views
		win_options = {
			wrap = false,
			signcolumn = "no",
			cursorcolumn = false,
			foldcolumn = "0",
			spell = false,
			list = false,
			conceallevel = 3,
			concealcursor = "nvic",
		},

		-- Skip confirmation for fast, common file edits (e.g. rename)
		skip_confirm_for_simple_edits = true,
		prompt_save_on_select_new_entry = false,

		-- Use Oil's default keymaps (like `<C-h>` to go up, `<C-l>` to open, etc.)
		use_default_keymaps = true,

		-- Controls file/directory visibility and sorting
		view_options = {
			show_hidden = true,
			is_hidden_file = function(name, _)
				return name:match("^%.") ~= nil
			end,
			is_always_hidden = function(_, _)
				return false
			end,
			natural_order = "fast", -- Sort intelligently for names with numbers
			case_insensitive = false,
			sort = {
				{ "type", "asc" },
				{ "name", "asc" },
			},
			highlight_filename = function(_, _, _, _)
				return nil
			end,
		},

		-- Additional arguments for SCP (SSH file transfers)
		extra_scp_args = {},

		-- Floating window configuration for `oil.open_float()` and `toggle_float()`
		float = {
			padding = 2, -- Padding inside the window
			max_width = 0.4, -- 40% of screen width max
			max_height = 0.4, -- 40% of screen height max
			border = "rounded", -- Can be: "single", "double", "shadow", etc.
			win_options = {
				winblend = 0, -- 0 = opaque, >0 = translucent
			},
			get_win_title = nil, -- Optional: override title
			preview_split = "auto",
			override = function(conf)
				return conf -- hook to modify `nvim_open_win()` config
			end,
		},

		-- File preview window config (when previewing on float split)
		preview_win = {
			update_on_cursor_moved = true,
			preview_method = "fast_scratch", -- best performance
			disable_preview = function(_)
				return false
			end,
			win_options = {},
		},

		-- Confirmation window for file actions
		confirmation = {
			max_width = 0.9,
			min_width = { 40, 0.4 },
			width = nil,
			max_height = 0.9,
			min_height = { 5, 0.1 },
			height = nil,
			border = "rounded",
			win_options = {
				winblend = 0,
			},
		},

		-- Progress indicator window
		progress = {
			max_width = 0.9,
			min_width = { 40, 0.4 },
			width = nil,
			max_height = { 10, 0.9 },
			min_height = { 5, 0.1 },
			height = nil,
			border = "rounded",
			minimized_border = "none",
			win_options = {
				winblend = 0,
			},
		},

		-- Floating SSH connection prompt
		ssh = {
			border = "rounded",
		},

		-- Floating help window for showing keymaps
		keymaps_help = {
			border = "rounded",
		},
	},

	config = function(_, opts)
		-- Load plugin with passed options
		require("oil").setup(opts)

		-- OPTIONAL: Press 'q' in oil buffer to quit (like Telescope)
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "oil",
			callback = function()
				vim.keymap.set("n", "q", "<cmd>q<CR>", { buffer = true, desc = "Close Oil buffer" })
				-- You could also add more scoped mappings here, like:
				-- vim.keymap.set("n", "<Esc>", "<cmd>q<CR>", { buffer = true })
			end,
		})
	end,
}
