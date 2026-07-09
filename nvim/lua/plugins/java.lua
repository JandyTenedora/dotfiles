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
	end,
}
