return {
    {
        "stevearc/conform.nvim",
        opts = {
            -- Configurações globais dos formatadores
            formatters = {
                -- 1. LUA (Stylua)
                stylua = {
                    prepend_args = { "--indent-type", "Spaces", "--indent-width", "4" },
                },

                -- 2. C / C++ / ARDUINO / DART (Clang-Format)
                -- Usamos clang-format para todas essas. O estilo Google é limpo,
                -- só forçamos IndentWidth: 4.
                clang_format = {
                    prepend_args = { "--style={BasedOnStyle: Google, IndentWidth: 4, ColumnLimit: 120}" },
                },

                -- 3. WEB (Javascript, Typescript, HTML, CSS, JSON, Yaml, Markdown)
                -- O Prettier cuida de quase tudo isso.
                prettier = {
                    prepend_args = { "--tab-width", "4", "--use-tabs", "false" },
                },
            },

            -- Aqui associamos as linguagens aos formatadores configurados acima
            formatters_by_ft = {
                lua = { "stylua" },

                -- C-Family
                c = { "clang_format" },
                cpp = { "clang_format" },
                arduino = { "clang_format" },

                -- DART (O truque para fugir do padrão de 2 espaços)
                -- Usamos clang-format porque o "dart format" oficial não aceita configs.

                -- Web
                javascript = { "prettier" },
                typescript = { "prettier" },
                html = { "prettier" },
                css = { "prettier" },
                json = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
            },
        },
    },
}
