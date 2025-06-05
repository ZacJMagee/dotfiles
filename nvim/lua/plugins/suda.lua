return {
	"lambdalisue/suda.vim",
	event = "VeryLazy",
	config = function()
		vim.g.suda_smart_edit = 1 -- Optional: enables smart edit
		-- You can put your keybinding here if you prefer
		vim.keymap.set("n", "<leader>W", ":SudaWrite<CR>", { silent = true })
	end,
}
