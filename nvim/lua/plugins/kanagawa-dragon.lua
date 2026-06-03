return {
	"rebelot/kanagawa.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		vim.o.background = "dark"
		require("kanagawa").setup({
			theme = "dragon",
			background = { dark = "dragon", light = "dragon" },
		})
		vim.cmd([[colorscheme kanagawa]])
		vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	end,
}
