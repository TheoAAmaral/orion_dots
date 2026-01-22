local api = vim.api
local fn = vim.fn

-- Configurações
local default_fqbn = "arduino:avr:uno"

-- Cria um grupo para evitar duplicação dos comandos se recarregar o arquivo
local group = api.nvim_create_augroup("ArduinoConfig", { clear = true })

-- O Autocommand: Roda toda vez que o FileType for definido como 'arduino'
api.nvim_create_autocmd("FileType", {
    pattern = "arduino", -- Neovim detecta .ino como filetype "arduino"
    group = group,
    callback = function(ev)
        -- 1. DETECÇÃO DO DIRETÓRIO
        -- 'ev.buf' é o ID do buffer atual
        local current_file = api.nvim_buf_get_name(ev.buf)
        local project_dir = fn.fnamemodify(current_file, ":h")
        local yaml_path = project_dir .. "/sketch.yaml"

        -- 2. LÓGICA DO SKETCH.YAML
        if fn.filereadable(yaml_path) == 0 then
            vim.notify("Arduino: Configurando projeto novo...", vim.log.levels.INFO)

            local default_port =
                vim.system({ "/home/theo/.config/scripts/arduino_board", default_fqbn }, { text = true }):wait().stdout
            -- Usamos fn.system (síncrono) para garantir que o arquivo exista ANTES do LSP tentar ler
            local cmd =
                string.format("arduino-cli board attach -b %s -p %s '%s'", default_fqbn, default_port, project_dir)
            fn.system(cmd)

            vim.notify("Arduino: sketch.yaml criado! Reiniciando LSP...", vim.log.levels.INFO)
            vim.cmd("LspRestart")
        end

        -- 3. KEYBINDS (IMPORTANTE: AQUI ELAS FICAM LOCAIS)
        -- Definindo as teclas apenas para este buffer (ev.buf)
        local opts = { buffer = ev.buf, silent = true }

        -- Função auxiliar para rodar comandos no terminal flutuante (se tiver Snacks) ou normal
        local function run_arduino(args)
            vim.cmd("write")
            local full_cmd = "arduino-cli " .. args

            -- Tenta usar Snacks (LazyVim), senão usa terminal padrão
            if _G.Snacks and _G.Snacks.terminal then
                Snacks.terminal(full_cmd, { cwd = project_dir, interactive = false })
            else
                local safe_cmd = "cd " .. fn.shellescape(project_dir) .. " && " .. full_cmd
                vim.cmd("botright 15split | term " .. safe_cmd)
            end
        end

        -- Definindo as teclas
        vim.keymap.set("n", "<leader>a", "", { desc = "Arduino" })
        vim.keymap.set("n", "<leader>av", function()
            run_arduino("compile .")
        end, vim.tbl_extend("force", opts, { desc = "Arduino: Compilar" }))

        vim.keymap.set("n", "<leader>au", function()
            run_arduino("upload .")
        end, vim.tbl_extend("force", opts, { desc = "Arduino: Upload" }))

        vim.keymap.set("n", "<leader>am", function()
            -- Monitor precisa ser interativo e forçar a porta
            vim.ui.input({ prompt = "Enter baud rate:" }, function(input)
                Snacks.terminal("arduino-cli monitor --config " .. input, { cwd = project_dir })
            end)
        end, vim.tbl_extend("force", opts, { desc = "Arduino: Monitor" }))
        vim.keymap.set("n", "<leader>aa", function()
            vim.ui.input({ prompt = "Enter FBQN:" }, function(input)
                local default_port = vim.system({ "/home/theo/.config/scripts/arduino_board", input }, { text = true })
                    :wait().stdout
                local cmd = string.format("arduino-cli board attach -b %s -p %s '%s'", input, default_port, project_dir)
                fn.system(cmd)
                vim.notify("Arduino: sketch.yaml criado! Reiniciando LSP...", vim.log.levels.INFO)
                vim.cmd("LspRestart")
            end)
        end, vim.tbl_extend("force", opts, { desc = "Arduino: Atualizar scratch.yaml" }))
    end,
})
return {}
