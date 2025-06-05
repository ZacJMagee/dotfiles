return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	version = false, -- Never set this value to "*"! Never!
	opts = function()
		return {
			debug = false,
			---@alias avante.ProviderName "claude" | "openai" | "azure" | "gemini" | "vertex" | "cohere" | "copilot" | "bedrock" | "ollama" | string
			provider = "gemini",
			-- WARNING: Since auto-suggestions are a high-frequency operation and therefore expensive,
			-- currently designating it as `copilot` provider is dangerous because: https://github.com/yetone/avante.nvim/issues/1048
			-- Of course, you can reduce the request frequency by increasing `suggestion.debounce`.
			auto_suggestions_provider = "claude",
			cursor_applying_provider = nil,
			memory_summary_provider = nil,
			---@type string | (fun(): string) | nil
			system_prompt = nil,
			rag_service = {
				enabled = false, -- Enables the rag service, requires OPENAI_API_KEY to be set
				host_mount = os.getenv("HOME"), -- Host mount path for the rag service (docker will mount this path)
				runner = "docker", -- The runner for the rag service, (can use docker, or nix)
				provider = "openai", -- The provider to use for RAG service. eg: openai or ollama
				llm_model = "", -- The LLM model to use for RAG service
				embed_model = "", -- The embedding model to use for RAG service
				endpoint = "https://api.openai.com/v1", -- The API endpoint for RAG service
				docker_extra_args = "", -- Extra arguments to pass to the docker command
			},
			web_search_engine = {
				provider = "tavily",
				proxy = nil,
				providers = {
					tavily = {
						api_key_name = "TAVILY_API_KEY",
						extra_request_body = {
							include_answer = "basic",
						},
						---@type WebSearchEngineProviderResponseBodyFormatter
						format_response_body = function(body)
							return body.answer, nil
						end,
					},
					brave = {
						api_key_name = "BRAVE_API_KEY",
						extra_request_body = {
							count = "10",
							result_filter = "web",
						},
						format_response_body = function(body)
							if body.web == nil then
								return "", nil
							end

							local jsn = vim.iter(body.web.results):map(function(result)
								return {
									title = result.title,
									url = result.url,
									snippet = result.description,
								}
							end)

							return vim.json.encode(jsn), nil
						end,
					},
				},
			},
			---@type AvanteSupportedProvider
			openai = {
				endpoint = "https://api.openai.com/v1",
				model = "gpt-4o",
				timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
				temperature = 0,
				max_completion_tokens = 16384, -- Increase this to include reasoning tokens (for reasoning models)
				reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
			},
			---@type AvanteSupportedProvider
			claude = {
				endpoint = "https://api.anthropic.com",
				model = "claude-3-5-sonnet-20241022",
				timeout = 30000, -- Timeout in milliseconds
				temperature = 0,
				max_tokens = 20480,
			},
			---@type AvanteSupportedProvider
			gemini = {
				endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
				model = "gemini-2.0-flash-001",
				timeout = 30000, -- Timeout in milliseconds
				temperature = 0,
				max_tokens = 8192,
			},
			---@type AvanteSupportedProvider
			ollama = {
				endpoint = "http://127.0.0.1:11434",
				timeout = 30000, -- Timeout in milliseconds
				options = {
					temperature = 0,
					num_ctx = 20480,
					keep_alive = "5m",
				},
			},
			---Specify the behaviour of avante.nvim
			---1. auto_focus_sidebar              : Whether to automatically focus the sidebar when opening avante.nvim. Default to true.
			---2. auto_suggestions = false, -- Whether to enable auto suggestions. Default to false.
			---3. auto_apply_diff_after_generation: Whether to automatically apply diff after LLM response.
			---                                     This would simulate similar behaviour to cursor. Default to false.
			---4. auto_set_keymaps                : Whether to automatically set the keymap for the current line. Default to true.
			---                                     Note that avante will safely set these keymap. See https://github.com/yetone/avante.nvim/wiki#keymaps-and-api-i-guess for more details.
			---5. auto_set_highlight_group        : Whether to automatically set the highlight group for the current line. Default to true.
			---6. jump_result_buffer_on_finish = false, -- Whether to automatically jump to the result buffer after generation
			---7. support_paste_from_clipboard    : Whether to support pasting image from clipboard. This will be determined automatically based whether img-clip is available or not.
			---8. minimize_diff                   : Whether to remove unchanged lines when applying a code block
			---9. enable_token_counting           : Whether to enable token counting. Default to true.
			behaviour = {
				auto_focus_sidebar = true,
				auto_suggestions = false, -- Experimental stage
				auto_suggestions_respect_ignore = false,
				auto_set_highlight_group = true,
				auto_set_keymaps = true,
				auto_apply_diff_after_generation = false,
				jump_result_buffer_on_finish = true,
				support_paste_from_clipboard = true,
				minimize_diff = true,
				enable_token_counting = true,
				enable_cursor_planning_mode = false,
				enable_claude_text_editor_tool_mode = false,
				use_cwd_as_project_root = false,
				auto_focus_on_diff_view = false,
			},
			history = {
				max_tokens = 4096,
				carried_entry_count = nil,
				storage_path = vim.fn.stdpath("state") .. "/avante",
				paste = {
					extension = "png",
					filename = "pasted-%Y-%m-%d-%H-%M-%S",
				},
			},
			highlights = {
				diff = {
					current = nil,
					incoming = nil,
				},
			},
			img_paste = {
				url_encode_path = true,
				template = "\nimage: $FILE_PATH\n",
			},
			windows = {
				---@alias AvantePosition "right" | "left" | "top" | "bottom" | "smart"
				position = "right",
				fillchars = "eob: ",
				wrap = true, -- similar to vim.o.wrap
				width = 30, -- default % based on available width in vertical layout
				height = 30, -- default % based on available height in horizontal layout
				sidebar_header = {
					enabled = true, -- true, false to enable/disable the header
					align = "center", -- left, center, right for title
					rounded = true,
				},
				input = {
					prefix = "> ",
					height = 8, -- Height of the input window in vertical layout
				},
				edit = {
					border = { " ", " ", " ", " ", " ", " ", " ", " " },
					start_insert = true, -- Start insert mode when opening the edit window
				},
				ask = {
					floating = false, -- Open the 'AvanteAsk' prompt in a floating window
					border = { " ", " ", " ", " ", " ", " ", " ", " " },
					start_insert = true, -- Start insert mode when opening the ask window
					---@alias AvanteInitialDiff "ours" | "theirs"
					focus_on_apply = "ours", -- which diff to focus after applying
				},
			},
			--- @class AvanteConflictConfig
			--- @class AvanteFileSelectorConfig
			file_selector = {
				provider = nil,
				-- Options override for custom providers
				provider_opts = {},
			},
			selector = {
				---@alias avante.SelectorProvider "native" | "fzf_lua" | "mini_pick" | "snacks" | "telescope" | fun(selector: avante.ui.Selector): nil
				provider = "telescope",
				provider_opts = {},
			},
			suggestion = {
				debounce = 600,
				throttle = 600,
			},
			disabled_tools = {}, ---@type string[]
			---@type AvanteLLMToolPublic[] | fun(): AvanteLLMToolPublic[]
			custom_tools = {},
			---@type AvanteSlashCommand[]
			slash_commands = {},
		}
	end,
	-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
	build = "make",
	-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		--- The below dependencies are optional,
		"echasnovski/mini.pick", -- for file_selector provider mini.pick
		"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
		"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
		"ibhagwan/fzf-lua", -- for file_selector provider fzf
		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
		"zbirenbaum/copilot.lua", -- for providers='copilot'
		{
			-- support for image pasting
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				-- recommended settings
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
					-- required for Windows users
					use_absolute_path = true,
				},
			},
		},
		{
			-- Make sure to set this up properly if you have lazy=true
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
}
