return require("noice").setup({
  cmdline = {
    enabled = true,
    view = "cmdline_popup",
    opts = {},
    format = {
      cmdline = { pattern = "^:", icon = "", lang = "vim" },
      search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
      search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
      filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
      lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
      help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
      input = {},
    },
  },
  messages = {
    enabled = true,
    view = "notify",
    view_error = "notify",
    view_warn = "notify",
    view_history = "messages",
    view_search = "virtualtext",
    opts = {
      timeout = 5000,
    },
  },
  popupmenu = {
    enabled = true,
    backend = "nui",
    kind_icons = true,
  },
  lsp = {
    progress = {
      enabled = true,
      view = "mini",
    },
    hover = {
      enabled = true,
      silent = false,
      view = nil,
      opts = {},
    },
    signature = {
      enabled = true,
      view = nil,
      opts = {},
    },
    -- message = {
    --   enabled = true,
    --   view = "notify",
    --   opts = {},
    -- },
  },
})
