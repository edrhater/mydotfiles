-- Example: ~/.config/nvim/lua/plugins.lua

return {
	-- ... other plugins

	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
		event = "InsertEnter", -- Load on entering insert mode for better performance
	},
}
