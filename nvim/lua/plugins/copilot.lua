return {
	"github/copilot.vim",
	config = function()
    vim.g.copilot_enabled = false -- Set Copilot to disabled by default
		-- Function to toggle Copilot
		local function toggle_copilot()
			local copilot_enabled = vim.g.copilot_enabled or false
			vim.g.copilot_enabled = not copilot_enabled

			if vim.g.copilot_enabled then
				print("Copilot enabled")
			else
				print("Copilot disabled")
			end
		end

		-- Create a user command for toggling Copilot
		vim.api.nvim_create_user_command("ToggleCopilot", toggle_copilot, {})

		-- Map <leader>F12 to toggle Copilot
		vim.api.nvim_set_keymap("n", "<leader><F12>", ":ToggleCopilot<CR>", { noremap = true, silent = false })
	end,
}
