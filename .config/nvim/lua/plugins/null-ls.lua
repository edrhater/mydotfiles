-- ~/.config/nvim/lua/plugins/null-ls.lua

return {
  "jose-elias-alvarez/null-ls.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local null_ls = require("null-ls")

    -- Define your formatters and linters
    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics

    null_ls.setup({
      sources = {
        -- Formatters
        formatting.prettier,             -- JavaScript, TypeScript, etc.
        formatting.black,                -- Python
        formatting.stylua,               -- Lua
        formatting.goimports,            -- Go
        formatting.rustfmt,              -- Rust
        formatting.clang_format,         -- C/C++
        -- Add more formatters as needed

        -- Linters (optional)
        diagnostics.eslint_d,            -- JavaScript/TypeScript
        diagnostics.flake8,              -- Python
        -- Add more linters as needed
      },
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          -- Set up a keybinding for formatting
          vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>f",
            "<cmd>lua vim.lsp.buf.format({ timeout_ms = 2000 })<CR>",
            { noremap = true, silent = true }
          )

          -- Optionally, set up auto formatting on save
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 2000 })
            end,
          })
        end
      end,
    })
  end,
}

