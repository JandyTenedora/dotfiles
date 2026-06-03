return {
	{
		"kdheepak/lazygit.nvim",
		lazy = false,
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			vim.keymap.set("n", "<leader>lg", ":LazyGit<CR>")
		end,
	},
	{
		"sindrets/diffview.nvim",
		lazy = false,
		config = function()
			vim.keymap.set("n", "<leader>dv", ":DiffviewOpen<CR>")
			vim.keymap.set("n", "<leader>dh", ":DiffviewFileHistory<CR>")
			vim.keymap.set("n", "<leader>dq", ":DiffviewClose<CR>")
			vim.keymap.set("n", "<leader>dbv", function()
				local branch = vim.fn.input("Branch to diff: ")
				if branch ~= "" then
					vim.cmd("DiffviewOpen " .. branch .. "...HEAD")
				end
			end)
		end,
	},
}
