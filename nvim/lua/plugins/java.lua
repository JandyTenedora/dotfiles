return {
	"mfussenegger/nvim-jdtls",
	lazy = false,
	config = function()
		local jdtls_java_home = "/Users/jandyt/.sdkman/candidates/java/21.0.7-tem"
		local launcher = vim.fn.expand("~/.config/nvim/jdtls-launcher.sh")
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		vim.lsp.config("jdtls", {
			cmd = { launcher },
			capabilities = capabilities,
			settings = {
				java = {
					configuration = {
						runtimes = {
							{ name = "JavaSE-17", path = os.getenv("JAVA_HOME") or "" },
							{ name = "JavaSE-21", path = jdtls_java_home, default = true },
						},
					},
				},
			},
		})
	end,
}
