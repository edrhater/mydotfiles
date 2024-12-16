vim.g.maplocalleader = " "
require("config.lazy")
require("lazy").setup("plugins")
vim.opt.number = true
vim.g.mapLeader = " "
vim.keymap.set("n", "<leader>n", ":Neotree<CR>", { noremap = true, silent = true })
local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
vim.cmd([[colorscheme tokyonight]])
-- Move between windows using Ctrl + {h,j,k,l}
vim.keymap.set("n", "<C-k>", "<C-w>k", { silent = true, desc = "Move to window above" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { silent = true, desc = "Move to window below" })
vim.keymap.set("n", "<C-h>", "<C-w>h", { silent = true, desc = "Move to window to the left" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { silent = true, desc = "Move to window to the right" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

-- Initialize Mason and its LSP configuration
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls", "pyright", "tsserver" }, -- Add your desired servers here
	handlers = {
		function(server_name)
			require("lspconfig")[server_name].setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})
		end,

		-- Example: Custom settings for specific servers
		["lua_ls"] = function()
			require("lspconfig").lua_ls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
					},
				},
			})
		end,
		-- Add other server-specific configurations here if needed
	},
})

-- Setup nvim-cmp.
local cmp = require("cmp")
local luasnip = require("luasnip")

-- Define capabilities for nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Define an `on_attach` function that will be used for all LSP servers
local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Define buffer-local keybindings for LSP
	local opts = { noremap = true, silent = true, buffer = bufnr }

	-- Example keybindings (you can customize these)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
	vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
	vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
	vim.keymap.set("n", "<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, opts)
	vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
end

-- Initialize nvim-cmp with keybindings
cmp.setup({
	snippet = {
		expand = function(args)
			-- For `luasnip` users.
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = {
		-- Navigate to the next item
		["<C-n>"] = cmp.mapping.select_next_item(),
		-- Navigate to the previous item
		["<C-p>"] = cmp.mapping.select_prev_item(),
		-- Scroll documentation up
		["<C-f>"] = cmp.mapping.scroll_docs(-4),
		-- Scroll documentation down
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		-- Trigger completion
		["<C-Space>"] = cmp.mapping.complete(),
		-- Confirm selection
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		-- Close completion menu
		["<C-e>"] = cmp.mapping.close(),
		-- Alternative navigation with Tab and Shift-Tab
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	},
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" }, -- For luasnip users.
	}, {
		{ name = "buffer" },
		{ name = "path" },
	}),
	formatting = {
		format = function(entry, vim_item)
			-- Customize the appearance of completion items
			return vim_item
		end,
	},
	experimental = {
		ghost_text = true,
	},
})

-- Setup filetype specific completion (optional)
cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "cmp_git" }, -- You need to install `cmp_git` if you want to use it
	}, {
		{ name = "buffer" },
	}),
})

-- Setup cmdline completion
cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})

-- Ensure this is added after both nvim-cmp and nvim-autopairs are loaded
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

-- You can customize other nvim-cmp settings here

-- Additional LSP configurations (if any) go here
