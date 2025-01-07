-- Create database directory if it doesn't exist
local db_dir = vim.fn.stdpath("data") .. "/databases"
vim.fn.mkdir(db_dir, "p")

-- Setup keymaps
vim.keymap.set('n', '<leader>fc', '<cmd>Telescope neoclip<cr>', { noremap = true, silent = true })

-- Safely require neoclip
local ok, neoclip = pcall(require, 'neoclip')
if not ok then
    return
end

-- Configure and setup neoclip
neoclip.setup({
    history = 1000,
    enable_persistent_history = true,
    length_limit = 1048576,
    continuous_sync = false,
    db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
    filter = nil,
    preview = true,
    prompt = nil,
    default_register = '"',
    default_register_macros = 'q',
    enable_macro_history = true,
    content_spec_column = false,
    disable_keycodes_parsing = false,
    on_select = {
        move_to_front = false,
        close_telescope = true,
    },
    on_paste = {
        set_reg = false,
        move_to_front = false,
        close_telescope = true,
    },
    on_replay = {
        set_reg = false,
        move_to_front = false,
        close_telescope = true,
    },
    on_custom_action = {
        close_telescope = true,
    },
    keys = {
        telescope = {
            i = {
                select = '<cr>',
                paste = '<c-p>',
                paste_behind = '<c-k>',
                replay = '<c-q>',
                delete = '<c-d>',
                edit = '<c-e>',
                custom = {},
            },
            n = {
                select = '<cr>',
                paste = 'p',
                paste_behind = 'P',
                replay = 'q',
                delete = 'd',
                edit = 'e',
                custom = {},
            },
        },
        fzf = {
            select = 'default',
            paste = 'ctrl-p',
            paste_behind = 'ctrl-k',
            custom = {},
        },
    },
})
-- Load telescope extension for neoclip
require('telescope').load_extension('neoclip')

-- Set up TextYankPost autocommand with proper handling for Neoclip
vim.api.nvim_create_autocmd('TextYankPost', {
    pattern = '*', -- Applies to all buffers
    callback = function()
        -- Highlight the yanked text briefly
        vim.highlight.on_yank({
            higroup = 'IncSearch', -- Highlight group used
            timeout = 150,         -- Duration of the highlight in milliseconds
        })

        -- Try to store the yank operation in Neoclip
        if vim.v.event.operator == 'y' and vim.v.event.regname == '' then
            local ok, neoclip_db = pcall(require, 'neoclip.db')
            if ok and neoclip_db and neoclip_db.store then
                -- Call the store method if it's available
                neoclip_db.store()
            end
        end
    end,
})

