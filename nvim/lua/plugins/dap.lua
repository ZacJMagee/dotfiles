return {
	-- Core DAP
	{
		"mfussenegger/nvim-dap",
		event = "VeryLazy",
		config = function()
			-- You can optionally configure some basic dap defaults here if you want
		end,
	},

	-- DAP UI
	{
		"rcarriga/nvim-dap-ui",
		event = "VeryLazy",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			require("dapui").setup()
			local dap, dapui = require("dap"), require("dapui")
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
		end,
	},

	-- DAP Virtual Text
	{
		"theHamsta/nvim-dap-virtual-text",
		event = "VeryLazy",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			enabled = true,
			enabled_commands = true,
			highlight_changed_variables = true,
			highlight_new_as_changed = false,
			show_stop_reason = true,
			commented = false,
			only_first_definition = true,
			all_references = false,
			clear_on_continue = false,
			virt_text_pos = vim.fn.has("nvim-0.10") == 1 and "inline" or "eol",
			all_frames = false,
			virt_lines = false,
			virt_text_win_col = nil,
		},
	},

	-- DAP Python
	{
		"mfussenegger/nvim-dap-python",
		ft = "python",
		dependencies = {
			"mfussenegger/nvim-dap",
		},
		config = function()
			-- You use system python (via nix develop shell)
			require("dap-python").setup("python3")
			require("dap-python").test_runner = "pytest"
		end,
	},

	-- Lazydev.nvim (Optional but Recommended for Typing/Docs)
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = { "nvim-dap-ui" }, -- for dap-ui types
		},
	},
}
