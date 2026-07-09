return {
	"stevearc/overseer.nvim",
	lazy = false,
	config = function()
		require("overseer").setup({
			template_dirs = { "overseer.template" },
			disable_template_modules = { "overseer.template.vscode", "overseer.template.cargo" },
		})

		-- Patch form cleanup to guard against double-close (BufLeave + submit race)
		local form_utils = require("overseer.form.utils")
		local orig_open = form_utils.open_form_win
		form_utils.open_form_win = function(bufnr, opts)
			local cleanup, set_layout = orig_open(bufnr, opts)
			local closed = false
			local safe_cleanup = function()
				if closed then
					return
				end
				closed = true
				cleanup()
			end
			return safe_cleanup, set_layout
		end

		vim.keymap.set("n", "<leader>oo", ":OverseerToggle<CR>", { silent = true })
		vim.keymap.set("n", "<leader>or", ":OverseerRun<CR>", { silent = true })
	end,
}
