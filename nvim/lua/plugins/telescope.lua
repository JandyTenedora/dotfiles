return {
	"nvim-telescope/telescope.nvim",
	branch = "master",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<C-p>", builtin.find_files, {})
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
		vim.keymap.set("n", "<leader>ds", builtin.lsp_document_symbols, {})
		vim.keymap.set("n", "<leader>ws", builtin.lsp_workspace_symbols, {})
		vim.keymap.set("n", "<leader>li", builtin.lsp_implementations, {})
	end,
}
