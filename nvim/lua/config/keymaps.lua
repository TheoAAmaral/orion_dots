-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- remove o mapping antigo
local avr_board = "arduino:avr:uno"

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

local function run_cmd(final_cmd)
    -- Se estiver usando versão recente do LazyVim com Snacks:
    local current_file = vim.api.nvim_buf_get_name(0)
    -- Pega o diretório do arquivo atual (ex: .../Prog/arduino/projeto1)
    local project_dir = vim.fn.fnamemodify(current_file, ":h")

    -- Salva o arquivo antes de rodar
    vim.cmd("write")

    -- Notifica qual projeto está sendo compilado (opcional, mas útil para confirmar)
    vim.notify("Rodando no projeto: " .. vim.fn.fnamemodify(project_dir, ":t"), vim.log.levels.INFO)

    -- Verifica se o LazyVim está usando o Snacks (novo padrão) ou terminal antigo
    if Snacks and Snacks.terminal then
        -- Abre o terminal JÁ dentro da pasta do projeto
        Snacks.terminal(final_cmd, {
            cwd = project_dir, -- O segredo está aqui: forçamos o CWD para a pasta do .ino
            win = { position = "float", border = "rounded" },
            interactive = false, -- Fecha automático se der sucesso (opcional)
        })
    else
        -- Fallback: Monta um comando "cd pasta && comando"
        vim.cmd("term cd " .. vim.fn.shellescape(project_dir) .. " && " .. final_cmd)
    end
end

-- 1. Compilar (Verify)
-- Usa as configurações do sketch.yaml automaticamente
vim.keymap.set("n", "<leader>av", function()
    vim.cmd("write") -- Salva antes de compilar
    run_cmd("arduino-cli compile .")
end, { desc = "Arduino: Verificar/Compilar" })

-- 2. Upload (Gravar na placa)
vim.keymap.set("n", "<leader>au", function()
    vim.cmd("write")
    run_cmd("arduino-cli upload .")
end, { desc = "Arduino: Upload" })

-- 3. Monitor Serial
-- É importante rodar em terminal para poder sair com Ctrl+C
vim.keymap.set("n", "<leader>am", function()
    -- O monitor precisa saber a porta. Se estiver no sketch.yaml, funciona direto.
    -- Se não, pode precisar forçar a flag -p /dev/ttyUSB0
    run_cmd("arduino-cli monitor")
end, { desc = "Arduino: Monitor Serial" })
