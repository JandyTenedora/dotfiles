return {
	"akinsho/toggleterm.nvim",
	lazy = false,
	config = function()
		require("toggleterm").setup({
			size = 10,
			direction = "horizontal",
			shade_terminals = false,
		})
		vim.keymap.set("n", "<leader>tt", ":ToggleTerm<CR>", { silent = true })
		vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { silent = true })
		vim.api.nvim_create_autocmd("TermOpen", {
			callback = function(args)
				if vim.api.nvim_buf_get_name(args.buf):match("lazygit") then
					vim.keymap.set("t", "<Esc>", "<Esc>", {
						buffer = args.buf,
						silent = true,
						nowait = true,
					})
				end
			end,
		})
	end,
}
