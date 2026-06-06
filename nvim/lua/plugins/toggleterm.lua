return {
	"akinsho/toggleterm.nvim",
	lazy = false,
	config = function()
		require("toggleterm").setup({
			direction = "float",
			shade_terminals = false,
			float_opts = {
				border = "rounded",
				width = function() return math.floor(vim.o.columns * 0.85) end,
				height = function() return math.floor(vim.o.lines * 0.85) end,
			},
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
