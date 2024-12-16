-- ~/.config/nvim/lua/plugins/mason-null-ls.lua

return {
	"jayp0521/mason-null-ls.nvim",
	dependencies = { "williamboman/mason.nvim", "jose-elias-alvarez/null-ls.nvim" },
	opts = {
		-- Ensure that formatters are installed
		ensure_installed = {
			"prettier",
			"black",
			"stylua",
			"goimports",
			"rustfmt",
			"clang-format",
			-- Add other formatters you need
		},
		automatic_installation = true,
	},
	config = function(_, opts)
		require("mason-null-ls").setup(opts)
	end,
}
