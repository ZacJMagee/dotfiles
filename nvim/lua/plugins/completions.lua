return {
	"saghen/blink.cmp",
	version = "1.*",
	dependencies = {
		"rafamadriz/friendly-snippets",
		"L3MON4D3/LuaSnip",
		"echasnovski/mini.snippets",
		"kaiser-Yang/blink-cmp-avante",
	},
	event = "InsertEnter",
	opts = {
		keymap = { preset = "default" },
		appearance = {
			nerd_font_variant = "mono",
		},
		completion = {
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 0,
				window = {
					border = "rounded",
				},
			},
			ghost_text = {
				enabled = true,
			},
			menu = {
				border = "rounded",
				winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
				draw = {
					treesitter = { "lsp" }, -- Enable treesitter highlighting for LSP items

					columns = {
						{
							"kind_icon",
							gap = 1,
						},
						{
							"label",
							gap = 1,
						},
						{
							"source_name",
							highlight = "Comment",
							min_width = 8,
						},
					},

					components = {
						kind_icon = {
							text = function(ctx)
								return ctx.item.kind_icon or ""
							end,
							highlight = function(ctx)
								return "CmpItemKind" .. (ctx.item.kind or "")
							end,
						},

						label = {
							text = function(ctx)
								-- colorful-menu draws both label + label_description together
								return require("colorful-menu").blink_components_text(ctx)
							end,
							highlight = function(ctx)
								return require("colorful-menu").blink_components_highlight(ctx)
							end,
						},

						source_name = {
							text = function(ctx)
								return ctx.source_name or ""
							end,
							highlight = "Comment",
						},
					},
				},
			},
		},
		sources = {
			default = { "avante", "lsp", "path", "snippets", "buffer" },
			per_filetype = {
				sql = { "snippets", "dadbod", "buffer" },
			},
			providers = {
				avante = {
					module = "blink-cmp-avante",
					name = "Avante",
					opts = {},
				},
				dadbod = {
					name = "Dadbod",
					module = "vim_dadbod_completion.blink",
				},
			},
		},
		signature = {
			enabled = true,
		},
		fuzzy = {
			implementation = "prefer_rust_with_warning",
		},
	},
	config = function(_, opts)
		require("blink.cmp").setup(opts)
		require("luasnip.loaders.from_vscode").lazy_load()
	end,
}
