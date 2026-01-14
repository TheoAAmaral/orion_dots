-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- remove o mapping antigo
vim.keymap.del("n", "<leader>E")

-- remove <C-e> antigo
-- vim.keymap.del("n", "<C-e>")

-- novo mapping seguro
vim.keymap.set("n", "<C-e>", function()
  Snacks.explorer()
end)
