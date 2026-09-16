-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- vim-herdr-navigation <C-h/j/k/l>. Must load here: LazyVim sets its own
-- <C-h/j/k/l> window maps on VeryLazy, after plugin config() has run.
dofile(vim.fn.expand("~/.config/herdr/links/vim-herdr-navigation/editor/nvim.lua"))
