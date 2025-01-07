-- File: ~/.config/nvim/lua/options.lua
vim.g.mapleader = " "  -- or whatever key you prefer
vim.g.maplocalleader = " "
-- vim.opt.lazyredraw = true

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.splitbelow = true
opt.splitright = true
opt.wrap = false
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.clipboard = "unnamedplus"
opt.scrolloff = 999
opt.virtualedit = "block"
opt.inccommand = "split"
opt.ignorecase = true
opt.termguicolors = true
opt.hlsearch = false
opt.conceallevel = 1
