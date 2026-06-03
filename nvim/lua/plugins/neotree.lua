return {
	"nvim-neo-tree/neo-tree.nvim",
	lazy = false,
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("neo-tree").setup({
			window = {
				mappings = {
					["<CR>"] = "open",
					["<Space>"] = "expand_all_nodes",
				},
			},
		})
		vim.keymap.set("n", "<C-n>", ":Neotree filesystem toggle left<CR>")
	end,
}
