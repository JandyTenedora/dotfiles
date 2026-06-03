return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"leoluz/nvim-dap-go",
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
	},
	config = function()
		require("dapui").setup({
			layouts = {
				{
					elements = {
						{ id = "scopes", size = 0.34 },
						{ id = "breakpoints", size = 0.33 },
						{ id = "stacks", size = 0.33 },
					},
					size = 40,
					position = "right",
				},
				{
					elements = {
						{ id = "repl", size = 0.6 },
						{ id = "watches", size = 0.4 },
					},
					size = 10,
					position = "bottom",
				},
			},
		})
		require("dap-go").setup()

		local dap, dapui = require("dap"), require("dapui")

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		-- dap.listeners.before.event_terminated.dapui_config = function()
		-- 	dapui.close()
		-- end
		-- dap.listeners.before.event_exited.dapui_config = function()
		-- 	dapui.close()
		-- end

		vim.keymap.set("n", "<Leader>dt", ":DapToggleBreakpoint<CR>")
		vim.keymap.set("n", "<Leader>dc", ":DapContinue<CR>")
		vim.keymap.set("n", "<Leader>dx", ":DapTerminate<CR>")
		vim.keymap.set("n", "<Leader>do", ":DapStepOver<CR>")
		vim.keymap.set("n", "<Leader>du", function() dapui.toggle() end)

		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				dapui.open()
				vim.cmd("Neotree filesystem show left")
				vim.schedule(function()
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						local buf = vim.api.nvim_win_get_buf(win)
						if vim.bo[buf].filetype == "dapui_watches" then
							vim.api.nvim_set_current_win(win)
							vim.cmd([[vsplit | terminal env ZDOTDIR=~/.config/nvim zsh]])
							vim.cmd("vertical resize 70")
							break
						end
					end
					-- return focus to the main editor window
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						local buf = vim.api.nvim_win_get_buf(win)
						if vim.bo[buf].buftype == "" and vim.bo[buf].filetype == "" then
							vim.api.nvim_set_current_win(win)
							break
						end
					end
				end)
			end,
		})
	end,
}
