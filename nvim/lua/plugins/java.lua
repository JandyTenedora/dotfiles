return {
	"mfussenegger/nvim-jdtls",
	lazy = false,
	config = function()
		local sdkman = os.getenv("HOME") .. "/.sdkman/candidates/java"
		local launcher = vim.fn.expand("~/.config/nvim/jdtls-launcher.sh")
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		vim.lsp.config("jdtls", {
			cmd = { launcher },
			capabilities = capabilities,
			root_markers = { ".project", ".classpath", "build.gradle", "pom.xml" },
			settings = {
				java = {
					configuration = {
						runtimes = {
							{ name = "JavaSE-17", path = sdkman .. "/17.0.14-amzn" },
							{ name = "JavaSE-21", path = sdkman .. "/21.0.7-tem", default = true },
							{ name = "JavaSE-25", path = sdkman .. "/25.0.1-tem" },
						},
					},
				},
			},
		})
		vim.lsp.enable("jdtls")

		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if not client or client.name ~= "jdtls" then
					return
				end
				local jdtls = require("jdtls")
				local opts = { buffer = args.buf }
				vim.keymap.set("n", "<leader>si", jdtls.super_implementation, opts)
				vim.keymap.set("n", "<leader>oi", jdtls.organize_imports, opts)
				vim.keymap.set("n", "<leader>ev", jdtls.extract_variable, opts)
				vim.keymap.set("n", "<leader>ec", jdtls.extract_constant, opts)
				vim.keymap.set("v", "<leader>em", function()
					jdtls.extract_method(true)
				end, opts)
			end,
		})
	end,
}
