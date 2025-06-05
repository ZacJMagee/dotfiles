return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" }, -- if you use the mini.nvim suite
	---@module 'render-markdown'
	---@type render.md.UserConfig

	opts = {
		completions = {
			blink = {
				enabled = true,
			},
		},
		render_modes = true,
	},
}
