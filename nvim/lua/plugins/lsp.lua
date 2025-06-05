return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPost", "BufNewFile", "BufEnter" }, -- ✅ lazy-load when needed
	config = function()
		local lspconfig = require("lspconfig")
		local cmp_capabilities = require("blink.cmp").get_lsp_capabilities()
		local schemastore = require("schemastore")

		-- Setup inlay hints on LspAttach
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("LspInlayHints", {}),
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if client and client.server_capabilities and client.server_capabilities.inlayHintProvider then
					vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
				end
			end,
		})

		local function on_attach(client, bufnr)
			local map = function(mode, keys, func, desc)
				vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
			end

			--TODO: Add in LSP Diagnostics, new line and also full error on keybind

			map("n", "gd", vim.lsp.buf.definition, "Go to Definition")
			map("n", "gD", vim.lsp.buf.declaration, "Go to Declaration")
			map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
			map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")
		end

		lspconfig.lua_ls.setup({
			cmd = { "lua-language-server" },
			capabilities = cmp_capabilities,
			on_attach = on_attach,
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					diagnostics = { globals = { "vim" } },
					workspace = {
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
						checkThirdParty = false,
					},
					telemetry = { enable = false },
					hint = { enable = true }, -- ✅ Inlay hints
				},
			},
			root_dir = lspconfig.util.root_pattern("init.lua", ".git"), -- optional but good
		})

		-- Python LSP
		lspconfig.pyright.setup({
			capabilities = cmp_capabilities,
			on_attach = on_attach,
			settings = {
				python = {
					analysis = {
						typeCheckingMode = "basic", -- Options: "off", "basic", "strict"
						autoSearchPaths = true,
						useLibraryCodeForTypes = true,
						autoImportCompletions = true,
						diagnosticMode = "workspace", -- Options: "openFilesOnly", "workspace"
					},
				},
			},
			root_dir = lspconfig.util.root_pattern(
				"pyproject.toml",
				"setup.py",
				"requirements.txt",
				".git",
				"shell.nix",
				"default.nix"
			),
		})

		-- Nix LSP
		lspconfig.nixd.setup({
			capabilities = cmp_capabilities,
			on_attach = on_attach,
			cmd = { "nixd" },
			root_dir = function(fname)
				return lspconfig.util.root_pattern("flake.nix", "shell.nix", "default.nix", ".git")(fname)
					or vim.fn.fnamemodify(fname, ":p:h")
			end,
			settings = {
				nixd = {
					nixpkgs = {
						expr = "import <nixpkgs> { }",
					},
					formatting = {
						command = { "/home/ai-dev/.nix-profile/bin/alejandra" },
					},
					eval = {
						enable = true,
					},
					options = {
						nixos = {
							expr = '(builtins.getFlake "/etc/nixos").nixosConfigurations.nixos.options',
						},
						home_manager = {
							expr = '(builtins.getFlake "/home/ai-dev/.config/nixpkgs").homeConfigurations.ai-dev.options',
						},
					},
				},
			},
		})

		-- Markdown (Marksman)
		lspconfig.marksman.setup({
			cmd = { "marksman", "server" }, -- Ensure 'marksman' is in your PATH
			filetypes = { "markdown", "markdown.mdx" },
			root_dir = lspconfig.util.root_pattern(".marksman.toml", ".git"),
			capabilities = cmp_capabilities,
			on_attach = on_attach,
			settings = {
				markdown = {
					code_action = {
						toc = false, -- Disable Table of Contents code action
						create_missing_file = false, -- Prevent automatic file creation
					},
					completion = {
						wiki = {
							style = "file-stem", -- Use file stem for wiki link completion
						},
					},
				},
			},
		})
		-- HTML LSP
		lspconfig.html.setup({
			capabilities = cmp_capabilities,
			on_attach = on_attach,
			filetypes = { "html" },
			cmd = { "vscode-html-language-server", "--stdio" }, -- provided by nix
			init_options = {
				configurationSection = { "html", "css", "javascript" },
				embeddedLanguages = {
					css = true,
					javascript = true,
				},
				provideFormatter = true,
			},
			settings = {
				html = {
					format = {
						enable = true,
					},
				},
			},
			root_dir = lspconfig.util.root_pattern(".git", "index.html"),
		})
		-- ✅ JSON LSP
		lspconfig.jsonls.setup({
			capabilities = cmp_capabilities,
			on_attach = on_attach,
			cmd = { "vscode-json-language-server", "--stdio" },
			filetypes = { "json", "jsonc" },
			settings = {
				json = {
					schemas = schemastore.json.schemas({
						select = {
							".eslintrc",
							"package.json",
							"tsconfig.json",
						},
					}),
					validate = { enable = true },
				},
			},
		})

		-- ✅ YAML LSP
		lspconfig.yamlls.setup({
			capabilities = cmp_capabilities,
			on_attach = on_attach,
			cmd = { "yaml-language-server", "--stdio" },
			filetypes = { "yaml", "yml" },
			settings = {
				yaml = {
					schemaStore = {
						enable = false,
						url = "",
					},
					schemas = schemastore.yaml.schemas(),
					validate = true,
					format = { enable = true },
					hover = true,
					completion = true,
				},
			},
		})

		-- CSS LSP
		lspconfig.cssls.setup({
			capabilities = cmp_capabilities,
			on_attach = on_attach,
			cmd = { "vscode-css-language-server", "--stdio" }, -- provided by nix
			filetypes = { "css", "scss", "less" },
			settings = {
				css = {
					validate = true,
				},
				scss = {
					validate = true,
				},
				less = {
					validate = true,
				},
			},
		})

		-- 🔧 Diagnostic UI Config
		vim.diagnostic.config({
			virtual_lines = {
				prefix = "●", -- could be "", ">>", or "⚠"

				spacing = 2,
				-- NOTE: Updated this to work wtih the new .11 setup
				current_line = true,
			},
			-- virtual_lines = {
			-- 	severity = {
			-- 		min = vim.diagnostic.severity.ERROR,
			-- 	},
			-- },
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
		})
	end,
}
