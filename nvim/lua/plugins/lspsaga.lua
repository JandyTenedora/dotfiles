return {
	"nvimdev/lspsaga.nvim",
	event = "LspAttach",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("lspsaga").setup({
			symbol_in_winbar = { enable = true },
			lightbulb = { enable = false },
			outline = { layout = "float" },
		})

		vim.keymap.set("n", "<leader>pd", "<cmd>Lspsaga peek_definition<CR>", {})
		vim.keymap.set("n", "<leader>pt", "<cmd>Lspsaga peek_type_definition<CR>", {})
		vim.keymap.set("n", "<leader>fi", "<cmd>Lspsaga finder<CR>", {})
		vim.keymap.set("n", "<leader>o", "<cmd>Lspsaga outline<CR>", {})
		vim.keymap.set("n", "<leader>ic", "<cmd>Lspsaga incoming_calls<CR>", {})
		vim.keymap.set("n", "<leader>oc", "<cmd>Lspsaga outgoing_calls<CR>", {})
		vim.keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", {})
		vim.keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", {})
	end,
}
