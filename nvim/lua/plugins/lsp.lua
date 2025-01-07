-- lsp.lua
-- Module table for LSP configuration
local M = {}

-- Main setup function that will be called from plugins.lua
M.setup = function()
    -- Set updatetime for quicker documentation display
    vim.opt.updatetime = 1000

    -- LSP Keymaps helper function
    local function set_lsp_keymaps(bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gD', '<cmd>split | lua vim.lsp.buf.definition()<CR>', opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, opts)
    end

    -- Generic on_attach function for most LSP servers
    local function on_attach(client, bufnr)
        -- Set omnifunc for buffer
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Set up buffer-local keymaps
        set_lsp_keymaps(bufnr)

        -- Enable inlay hints if supported
        if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true)
        end

        local function show_documentation()
            -- First check if we're in a LSP hover-capable context
            local filetype = vim.bo.filetype
            local cursor_node = vim.treesitter.get_node()

            -- Try to show LSP hover documentation first
            local success, _ = pcall(vim.lsp.buf.hover)
            if not success then
                -- Fallback to showing diagnostics only if hover failed
                local float_opts = {
                    focusable = false,
                    close_events = { "BufLeave", "CursorMoved", "FocusLost" },
                    border = 'rounded',
                    source = 'always',
                    prefix = ' ',
                    scope = 'cursor',
                }
                vim.diagnostic.open_float(nil, float_opts)
            end
        end


        -- Set up automatic documentation display on cursor hold in both normal and insert mode
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = bufnr,
            callback = show_documentation
        })

        -- Notify when LSP attaches
        vim.notify(string.format("LSP [%s] started on buffer %s", client.name, bufnr), vim.log.levels.INFO)
    end

    -- Special on_attach for Nix files
    local function on_attach_nix(client, bufnr)
        -- Disable semantic tokens for nix files
        client.server_capabilities.semanticTokensProvider = nil

        -- Call the regular on_attach
        on_attach(client, bufnr)
    end

    -- Get LSP capabilities with nvim-cmp support
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    -- Special capabilities for Nix
    local nix_capabilities = vim.tbl_deep_extend("force", {}, capabilities)
    nix_capabilities.textDocument.semanticTokens = {
        dynamicRegistration = false,
        formats = {},
        requests = {
            range = false,
            full = {
                delta = false
            }
        },
        tokenTypes = {},
        tokenModifiers = {}
    }

    -- Default configuration for all language servers
    local default_config = {
        capabilities = capabilities,
        on_attach = on_attach,
        flags = {
            debounce_text_changes = 300,
        }
    }

    -- Get lspconfig module
    local lspconfig = require('lspconfig')

    -- Configure Lua LSP
    lspconfig.lua_ls.setup(vim.tbl_deep_extend("force", default_config, {
        cmd = { "/run/current-system/sw/bin/lua-language-server" },
        settings = {
            Lua = {
                diagnostics = {
                    globals = { 'vim' }
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    }))

    -- Pyright LSP Configuration
    local function get_python_settings()
        return {
            settings = {
                python = {
                    analysis = {
                        -- Core Analysis Features
                        -- These settings help Pyright understand your project structure
                        autoSearchPaths = true,           -- Automatically finds Python files in your project
                        useLibraryCodeForTypes = true,    -- Uses installed packages for better type information
                        diagnosticMode = "openFilesOnly", -- Only check files you're actively working on

                        -- Type Checking Configuration
                        -- We use 'off' for simpler applications to reduce noise while maintaining basic safety
                        typeCheckingMode = "off",

                        -- Inlay Hints Configuration
                        -- These are the visual type hints that appear in your code
                        -- We configure these to show only the most useful information
                        inlayHints = {
                            variableTypes = false,      -- Hide variable types since they're usually obvious
                            functionReturnTypes = true, -- Show return types to understand function outputs
                            parameterTypes = false      -- Hide parameter types to reduce visual clutter
                        },

                        -- Import Handling
                        -- Helps with managing imports in your code
                        autoImportCompletions = true, -- Suggests imports as you type

                        -- Error Reporting Settings
                        -- All set to "warning" instead of "error" for a less intrusive experience
                        diagnosticSeverityOverrides = {
                            -- Type-related warnings
                            reportGeneralTypeIssues = "warning",    -- General typing issues
                            reportOptionalMemberAccess = "warning", -- Optional attribute access
                            reportOptionalSubscript = "warning",    -- Optional indexing issues
                            reportPrivateUsage = "warning",         -- Private member usage
                            reportUnknownMemberType = "none",       -- Unknown attribute types
                            reportUnknownParameterType = "none",    -- Unknown parameter types
                            reportUnknownVariableType = "warning",  -- Unknown variable types

                            -- Import-related warnings
                            reportDuplicateImport = "warning",  -- Duplicate imports
                            reportMissingImports = "warning",   -- Missing imports
                            reportUndefinedVariable = "warning" -- Undefined variables
                        },
                    },
                },
            },

            -- Project Root Detection
            -- These patterns help Pyright identify your project's root directory
            root_dir = require('lspconfig').util.root_pattern(
                ".git",            -- Git repository root
                "setup.py",        -- Python package root
                "setup.cfg",       -- Alternative package root
                "pyproject.toml",  -- Modern Python project root
                "requirements.txt" -- Project dependencies file
            ),

            -- Enable LSP for single Python files
            -- Useful when working with standalone scripts
            single_file_support = true,

            -- LSP Capabilities
            -- Enables advanced LSP features
            capabilities = require('cmp_nvim_lsp').default_capabilities(),

            -- On Attach Function
            -- Configures what happens when Pyright attaches to a buffer
            on_attach = function(client, bufnr)
                -- Enable inlay hints if supported
                if client.server_capabilities.inlayHintProvider then
                    vim.lsp.inlay_hint(bufnr, true)
                end
            end,
        }
    end

    -- Set up Pyright with our configuration
    require('lspconfig').pyright.setup(
        vim.tbl_deep_extend(
            "force",
            {}, -- Empty table as default_config
            get_python_settings()
        )
    )

    -- Diagnostic Signs Configuration
    -- These symbols appear in the gutter to indicate issues
    vim.fn.sign_define('DiagnosticSignError', {
        text = '✘',
        texthl = 'DiagnosticSignError'
    })
    vim.fn.sign_define('DiagnosticSignWarn', {
        text = '▲',
        texthl = 'DiagnosticSignWarn'
    })
    vim.fn.sign_define('DiagnosticSignInfo', {
        text = '»',
        texthl = 'DiagnosticSignInfo'
    })
    vim.fn.sign_define('DiagnosticSignHint', {
        text = '⚡',
        texthl = 'DiagnosticSignHint'
    })

    -- Global Diagnostic Configuration
    -- Controls how diagnostic messages appear in your code
    vim.diagnostic.config({
        virtual_text = true,      -- Show diagnostics beside code
        signs = true,             -- Show signs in the gutter
        underline = true,         -- Underline problematic code
        update_in_insert = false, -- Only update diagnostics after leaving insert mode
        severity_sort = true,     -- Show severe diagnostics first
        float = {                 -- Configuration for floating windows
            border = 'rounded',   -- Add rounded borders
            source = 'always',    -- Always show diagnostic source
            header = '',          -- No header
            prefix = '',          -- No prefix
        },
    })
    -- ADD THE NEW SIGNATURE HELP CONFIGURATION HERE
    -- Configure signature help to appear automatically
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers["textDocument/signatureHelp"],
        {
            -- Show on these characters
            trigger_characters = { "(", ",", " " },
            -- Window styling
            border = "rounded",
            focusable = false,
            -- Window behavior
            close_events = { "CursorMoved", "BufHidden", "InsertCharPre" },
        }
    )


    -- Configure Nix LSP
    lspconfig.nixd.setup({
        capabilities = nix_capabilities,
        on_attach = on_attach_nix,
        cmd = { "nixd" },
        settings = {
            nixd = {
                nixpkgs = {
                    expr = "import <nixpkgs> { }"
                },
                formatting = {
                    command = { "alejandra" }
                },
                options = {
                    nixos = {
                        expr = '(builtins.getFlake "/etc/nixos").nixosConfigurations.nixos.options'
                    },
                    home_manager = {
                        expr = '(builtins.getFlake "/etc/nixos").homeConfigurations.zacmagee.options'
                    }
                }
            }
        }
    })

    -- Configure Rust LSP with essential settings and error handling
    lspconfig.rust_analyzer.setup(vim.tbl_deep_extend("force", default_config, {
        cmd = { "/run/current-system/sw/bin/rust-analyzer" },
        settings = {
            ['rust-analyzer'] = {
                -- Essential cargo settings
                cargo = {
                    allFeatures = true,
                    loadOutDirsFromCheck = true,
                },
                -- Basic checkOnSave configuration
                checkOnSave = {
                    enable = true,
                    command = "check",
                },
                -- Enable proc macros
                procMacro = {
                    enable = true,
                },
                -- Enable diagnostics
                diagnostics = {
                    enable = true,
                }
            }
        },
        flags = {
            debounce_text_changes = 500,
            allow_incremental_sync = false,
            exit_timeout = 0,
        },
        on_attach = function(client, bufnr)
            -- Set up error handling
            local notify_ns = vim.api.nvim_create_namespace('rust-analyzer-notify')
            local last_error_time = 0
            local error_count = 0

            -- Override client notification handler to reduce error spam
            client.notify = function(method, params)
                if method == "window/showMessage" and params.type == vim.lsp.protocol.MessageType.Error then
                    local current_time = vim.loop.now()
                    if current_time - last_error_time > 5000 then
                        last_error_time = current_time
                        error_count = 1
                    else
                        error_count = error_count + 1
                        if error_count > 5 then
                            return
                        end
                    end
                end
            end

            -- Call default on_attach
            default_config.on_attach(client, bufnr)

            -- Inspect capabilities silently
            local _ = client.server_capabilities

            -- Reduce initial load after delay
            vim.defer_fn(function()
                if client.server_capabilities then
                    client.config.flags.debounce_text_changes = 150
                end
            end, 2000)
        end,
    }))

    -- Configure Bash LSP
    lspconfig.bashls.setup(default_config)

    -- Configure Markdown LSP
    lspconfig.marksman.setup(vim.tbl_deep_extend("force", default_config, {
        cmd = { "/nix/store/1n5k455yyh6kq1b0n4rpwgj4xxrs6pvv-marksman-2024-10-07/bin/marksman" },
        filetypes = { "markdown", "markdown.mdx" },
        root_dir = lspconfig.util.root_pattern(".git", ".marksman.toml"),
        single_file_support = true
    }))

    -- Configure SQL LSP
    lspconfig.sqlls.setup(default_config)

    -- Configure TypeScript/JavaScript LSP with enhanced settings for Next.js
    lspconfig.tsserver.setup(vim.tbl_deep_extend("force", default_config, {
        init_options = {
            preferences = {
                disableSuggestions = true,
            }
        },
        settings = {
            typescript = {
                inlayHints = {
                    includeInlayParameterNameHints = 'all',
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                },
                suggest = {
                    completeFunctionCalls = true,
                },
            },
            javascript = {
                inlayHints = {
                    includeInlayParameterNameHints = 'all',
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                },
                suggest = {
                    completeFunctionCalls = true,
                },
            },
        },
    }))

    -- Add ESLint LSP configuration
    lspconfig.eslint.setup(vim.tbl_deep_extend("force", default_config, {
        on_attach = function(client, bufnr)
            -- Call the default on_attach
            on_attach(client, bufnr)

            -- Auto-fix on save
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                command = "EslintFixAll",
            })
        end,
    }))
end

return M
