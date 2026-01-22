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

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "dart" },
    callback = function()
        vim.schedule(function()
            vim.keymap.set("n", "<leader>F", "", { desc = "flutter" })
            vim.keymap.set("n", "<leader>Fr", "<cmd>FlutterRun<cr>", { desc = "run" })
            vim.keymap.set("n", "<leader>FR", "<cmd>FlutterReload<cr>", { desc = "hot reload" })
            vim.keymap.set("n", "<leader>Fs", "<cmd>FlutterRestart<cr>", { desc = "hot restart" })
            vim.keymap.set("n", "<leader>Fd", "<cmd>FlutterDevices<cr>", { desc = "select sevice" })
            vim.keymap.set("n", "<leader>Fq", "<cmd>FlutterQuit<cr>", { desc = "quit" })
        end)
    end,
})
