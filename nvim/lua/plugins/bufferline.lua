return {
	"akinsho/bufferline.nvim",
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("bufferline").setup({
			options = {
				custom_filter = function(buf)
					local ft = vim.bo[buf].filetype
					local bt = vim.bo[buf].buftype
					local excluded_ft = {
						"dapui_watches", "dapui_breakpoints", "dapui_scopes",
						"dapui_stacks", "dapui_console", "dap-repl", "neo-tree",
					}
					for _, f in ipairs(excluded_ft) do
						if ft == f then return false end
					end
					if bt == "terminal" then return false end
					return true
				end,
			},
		})
		vim.keymap.set("n", "gb", ":BufferLineCycleNext<CR>", { silent = true })
		vim.keymap.set("n", "gB", ":BufferLineCyclePrev<CR>", { silent = true })
	end,
}
