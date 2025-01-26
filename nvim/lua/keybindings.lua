-- Require the necessary Telescope modules
local builtin = require('telescope.builtin')
local actions = require("telescope.actions")

-- Move selected lines down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move selected lines down" })

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

-- Copy to clipboard in normal and visual mode
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Copy to system clipboard" })

-- Copy whole line to clipboard in normal mode
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Copy line to system clipboard" })

-- Delete without changing the clipboard in normal and visual mode
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yanking to clipboard" })

-- Disable the 'Q' command in normal mode to enter Ex mode
vim.keymap.set("n", "Q", "<nop>", { desc = "Disable Ex mode" })

-- Format the current buffer using LSP
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { silent = true, noremap = true, desc = "Format buffer with LSP" })

-- Create an autocommand group for our diagnostic sync
vim.api.nvim_create_augroup('DiagnosticSync', { clear = true })

-- Set up the autocmd to sync diagnostics to quickfix
vim.api.nvim_create_autocmd('DiagnosticChanged', {
    group = 'DiagnosticSync',
    callback = function()
        -- Get the current quickfix list properties
        local qf_properties = vim.fn.getqflist({ title = 0 })

        -- Only update if quickfix list is already showing diagnostics
        if qf_properties.title == 'Diagnostics' then
            local diagnostics = vim.diagnostic.get(0)
            local errors = vim.tbl_filter(
                function(d) return d.severity == vim.diagnostic.severity.ERROR end,
                diagnostics
            )

            -- Convert diagnostics to quickfix items
            local items = vim.diagnostic.toqflist(errors)

            -- Set the quickfix list with title in one call
            vim.fn.setqflist({}, 'r', {
                title = 'Diagnostics',
                items = items
            })
        end
    end
})

-- Keybind to initialize current buffer diagnostic quickfix list
vim.keymap.set('n', '<leader>q', function()
    local diagnostics = vim.diagnostic.get(0)
    local errors = vim.tbl_filter(
        function(d) return d.severity == vim.diagnostic.severity.ERROR end,
        diagnostics
    )

    -- Convert diagnostics to quickfix items
    local items = vim.diagnostic.toqflist(errors)

    -- Set the quickfix list with title in one call
    vim.fn.setqflist({}, 'r', {
        title = 'Diagnostics',
        items = items
    })

    -- Open or close quickfix window based on whether there are items
    if #items > 0 then
        vim.cmd('copen')
    else
        vim.cmd('cclose')
    end
end, { desc = "Show current buffer diagnostics in quickfix" })

-- Keybind to initialize project-wide diagnostic quickfix list
vim.keymap.set('n', '<leader>qq', function()
    -- Get all buffers
    local buffers = vim.api.nvim_list_bufs()
    local all_diagnostics = {}

    -- Collect diagnostics from all buffers
    for _, bufnr in ipairs(buffers) do
        -- Only check loaded buffers
        if vim.api.nvim_buf_is_loaded(bufnr) then
            local buf_diagnostics = vim.diagnostic.get(bufnr)
            for _, diagnostic in ipairs(buf_diagnostics) do
                table.insert(all_diagnostics, diagnostic)
            end
        end
    end

    -- Filter for errors only
    local errors = vim.tbl_filter(
        function(d) return d.severity == vim.diagnostic.severity.ERROR end,
        all_diagnostics
    )

    -- Convert diagnostics to quickfix items
    local items = vim.diagnostic.toqflist(errors)

    -- Set the quickfix list with title in one call
    vim.fn.setqflist({}, 'r', {
        title = 'Project Diagnostics',
        items = items
    })

    -- Open or close quickfix window based on whether there are items
    if #items > 0 then
        vim.cmd('copen')
    else
        print("No project-wide diagnostics found")
        vim.cmd('cclose')
    end
end, { desc = "Show project-wide diagnostics in quickfix" })

-- Jump to next and previous items in quickfix list with Ctrl-k and Ctrl-j
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "Next quickfix item" })
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "Previous quickfix item" })

-- Jump to next and previous items in location list with leader-k and leader-j
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Next location list item" })
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Previous location list item" })

-- Substitute the word under cursor in the whole file
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Substitute word under cursor" })

-- Move to the left window
vim.keymap.set("n", "<leader>wh", "<C-w>h", { silent = true, desc = "Move to left window" })

-- Move to the right window
vim.keymap.set("n", "<leader>wl", "<C-w>l", { silent = true, desc = "Move to right window" })

-- Move to the upper window
vim.keymap.set("n", "<leader>wk", "<C-w>k", { silent = true, desc = "Move to window above" })

-- Move to the lower window
vim.keymap.set("n", "<leader>wj", "<C-w>j", { silent = true, desc = "Move to window below" })

-- Goto Preview bindings
vim.keymap.set("n", "gp", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
    { noremap = true, desc = "Preview definition" })
vim.keymap.set("n", "gP", "<cmd>lua require('goto-preview').close_all_win()<CR>",
    { noremap = true, desc = "Close all preview windows" })
vim.keymap.set("n", "pi", "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>",
    { noremap = true, desc = "Preview implementation" })
vim.keymap.set("n", "gpt", "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>",
    { noremap = true, desc = "Preview type definition" })
vim.keymap.set("n", "gpD", "<cmd>lua require('goto-preview').goto_preview_declaration()<CR>",
    { noremap = true, desc = "Preview declaration" })
vim.keymap.set("n", "gpr", "<cmd>lua require('goto-preview').goto_preview_references()<CR>",
    { noremap = true, desc = "Preview references" })


-- Obsidian related keybindings
local obsidian_path = vim.fn.expand("~/ObsidianSync/NvimZettelkasten")

-- For review workflow
-- Move file in current buffer to zettelkasten folder
vim.keymap.set("n", "<leader>ok", function()
    local current_file = vim.fn.expand("%:p")
    local zettelkasten_path = obsidian_path .. "/zettelkasten"
    vim.cmd("!mv '" .. current_file .. "' '" .. zettelkasten_path .. "'")
    vim.cmd("bd")
end, { desc = "Move current note to zettelkasten" })

-- Delete file in current buffer
vim.keymap.set("n", "<leader>odd", function()
    local current_file = vim.fn.expand("%:p")
    vim.cmd("!rm '" .. current_file .. "'")
    vim.cmd("bd")
end, { desc = "Delete current note" })

-- convert note to template and remove leading white space
vim.keymap.set("n", "<leader>on", ":ObsidianTemplate Note Template<cr> :lua vim.cmd([[1,/^\\S/s/^\\n\\{1,}//]])<cr>",
    { desc = "Convert to note template" })

-- Suda write keybinding
vim.keymap.set("n", "<leader>W", ":SudaWrite<CR>", { silent = true, desc = "Write with sudo privileges" })


-- Telescope Keybindings
vim.keymap.set('n', '<leader>ff', ":Telescope find_files<CR>", { silent = true, desc = "Find files" })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Search help tags" })
vim.keymap.set('n', '<leader>ft', '<cmd>Telescope tags<CR>', { noremap = true, silent = true, desc = "Search tags" })
vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Search document symbols" })
vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "Search word under cursor" })
vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Search keymaps" })
vim.keymap.set('n', '<leader>e', ":Telescope emoji<CR>", { noremap = true, silent = true, desc = "Emoji picker" })
vim.keymap.set("n", "<leader>/", function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = true,
        layout_config = { width = 0.9 },
    }))
end, { desc = "Fuzzy find in current buffer" })

local function setup_telescope_keybindings()
    return {
        n = {
            ["<C-w>"] = { actions.send_selected_to_qflist + actions.open_qflist, "Send to quickfix and open" },
        },
        i = {
            ["<C-j>"] = { actions.cycle_history_next, "Next history item" },
            ["<C-k>"] = { actions.cycle_history_prev, "Previous history item" },
            ["<CR>"] = { actions.select_default, "Select default" },
            ["<C-w>"] = { actions.send_selected_to_qflist + actions.open_qflist, "Send to quickfix and open" },
            ["<C-S-d>"] = { actions.delete_buffer, "Delete buffer" },
            ["<C-s>"] = { actions.cycle_previewers_next, "Next previewer" },
            ["<C-a>"] = { actions.cycle_previewers_prev, "Previous previewer" },
        },
    }
end

return {
    setup_telescope_keybindings = setup_telescope_keybindings
}
