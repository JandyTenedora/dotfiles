return {
	"stevearc/overseer.nvim",
	lazy = false,
	config = function()
		require("overseer").setup({
			template_dirs = { "overseer.template" },
		})
		vim.keymap.set("n", "<leader>oo", ":OverseerToggle<CR>", { silent = true })
		vim.keymap.set("n", "<leader>or", ":OverseerRun<CR>", { silent = true })
	end,
}
