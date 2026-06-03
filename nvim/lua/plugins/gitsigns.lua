return {
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns
					local opts = { buffer = bufnr }

					vim.keymap.set("n", "]h", gs.next_hunk, opts)
					vim.keymap.set("n", "[h", gs.prev_hunk, opts)
					vim.keymap.set("n", "<leader>hs", gs.stage_hunk, opts)
					vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk, opts)
					vim.keymap.set("n", "<leader>hr", gs.reset_hunk, opts)
					vim.keymap.set("n", "<leader>hp", gs.preview_hunk, opts)
					vim.keymap.set("n", "<leader>hb", gs.toggle_current_line_blame, opts)
				end,
			})
		end,
	},
	{ "tpope/vim-fugitive" },
}
