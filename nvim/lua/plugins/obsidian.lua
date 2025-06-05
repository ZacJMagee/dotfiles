return {
	"epwalsh/obsidian.nvim",
	version = "*",
	lazy = true,
	event = {
		"BufReadPre " .. vim.fn.expand("~/ObsidianSync/NvimZettelkasten") .. "/**.md",
		"BufNewFile " .. vim.fn.expand("~/ObsidianSync/NvimZettelkasten") .. "/**.md",
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {
		workspaces = {
			{
				name = "AiVault",
				path = "~/ObsidianSync/NvimZettelkasten/",
			},
		},
		notes_subdir = "inbox",
		completion = {
			nvim_cmp = true,
			min_chars = 2,
		},
		daily_notes = {
			folder = "notes/dailies",
			date_format = "%Y-%m-%d",
			alias_format = "%B %-d, %Y",
			default_tags = { "daily-notes" },
		},
		mappings = {
			["gf"] = {
				action = function()
					return require("obsidian").util.gf_passthrough()
				end,
				opts = { noremap = false, expr = true, buffer = true },
			},
			["<leader>ch"] = {
				action = function()
					return require("obsidian").util.toggle_checkbox()
				end,
				opts = { buffer = true },
			},
			["<cr>"] = {
				action = function()
					return require("obsidian").util.smart_action()
				end,
				opts = { buffer = true, expr = true },
			},
		},
		preferred_link_style = "wiki",
		disable_frontmatter = true,
		note_id_func = function(title)
			local suffix = ""
			if title then
				suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
			else
				for _ = 1, 4 do
					suffix = suffix .. string.char(math.random(65, 90))
				end
			end
			return tostring(os.time()) .. "-" .. suffix
		end,
		templates = {
			folder = "templates",
			date_format = "%Y-%m-%d",
			time_format = "%H:%M",
		},
		picker = {
			name = "telescope.nvim",
		},
		ui = {
			enable = false,
			update_debounce = 200,
			max_file_length = 5000,
		},
		attachments = {
			img_folder = "assets/imgs",
		},
	},
}
