vim.keymap.set("n", "<leader>tt", "<cmd>Oil<CR>", { desc = "Open oil.nvim file browser" })

vim.keymap.set("n", "<leader>tt", function()
	require("oil").toggle_float()
end, { desc = "Toggle Oil Float" })

vim.keymap.set("n", "<leader>fm", function()
	require("conform").format({ async = true })
end, { desc = "Format file with Conform" })
-- Move selected lines down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move selected lines down" })

vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })

-- Move selected lines up in visual mode
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move selected lines up" })

-- Move half-page down and recenter
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Move half-page down and center cursor" })

-- Move half-page up and recenter
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Move half-page up and center cursor" })

-- Move to the next search result and recenter, with visual selection restored if present
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })

-- Move to the previous search result and recenter, with visual selection restored if present
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

-- Smarter delete without yanking
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yanking" })
vim.keymap.set({ "n", "v" }, "<leader>c", [["_c]], { desc = "Change without yanking" })
vim.keymap.set({ "n", "v" }, "<leader>x", [["_x]], { desc = "Delete char without yanking" })

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- convert note to template and remove leading white space
vim.keymap.set(
	"n",
	"<leader>on",
	":ObsidianTemplate Note Template<cr> :lua vim.cmd([[1,/^\\S/s/^\\n\\{1,}//]])<cr>",
	{ desc = "Convert to note template" }
)
