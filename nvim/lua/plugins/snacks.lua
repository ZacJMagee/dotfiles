return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {

		image = { enabled = true },
		indent = { enabled = true },
		lazygit = { enabled = true },
		notifier = {
			enabled = true,
			notification = {
				border = "rounded",
				zindex = 100,
				width = 0.6,
				height = 0.6,
				minimal = false,
				title = " Notification History ",
				title_pos = "center",
				ft = "markdown",
				bo = { filetype = "snacks_notif_history", modifiable = false },
				wo = { winhighlight = "Normal:SnacksNotifierHistory" },
				keys = { q = "close" },
			},
			notification_history = {
				border = "rounded",
				zindex = 100,
				ft = "markdown",
				wo = {
					winblend = 5,
					wrap = false,
					conceallevel = 2,
					colorcolumn = "",
				},
				bo = { filetype = "snacks_notif" },
			},
		},
		notify = { enabled = true },
		scope = { enabled = true },
	},
	vim.keymap.set("n", "<leader>gg", function()
		require("snacks.lazygit").open()
	end, { desc = "Open LazyGit (Snacks)" }),
	vim.keymap.set("n", "<leader>nn", function()
		require("snacks").notifier.show_history()
	end, { desc = "Show notificatoin history" }),
}
