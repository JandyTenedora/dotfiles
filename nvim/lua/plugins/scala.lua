return {
	"scalameta/nvim-metals",
	dependencies = { "nvim-lua/plenary.nvim", "mfussenegger/nvim-dap" },
	ft = { "scala", "sbt" },
	config = function()
		local metals_config = require("metals").bare_config()
		metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()
		metals_config.settings = {
			showImplicitArguments = true,
			showImplicitConversionsAndClasses = true,
			showInferredType = true,
		}
		metals_config.root_patterns = { "build.sbt", "build.sc", "project/build.properties" }

		metals_config.on_attach = function(client, bufnr)
			require("metals").setup_dap()

			local dap = require("dap")
			dap.configurations.scala = {
				{
					type = "scala",
					request = "launch",
					name = "Run file",
					metals = { runType = "runOrTestFile" },
				},
				{
					type = "scala",
					request = "launch",
					name = "Run test target",
					metals = { runType = "testTarget" },
				},
			}
		end

		local group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "scala", "sbt" },
			callback = function()
				require("metals").initialize_or_attach(metals_config)
				vim.lsp.codelens.refresh()
			end,
			group = group,
		})
	end,
}
